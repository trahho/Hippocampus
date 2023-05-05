//
//  DataStoreTests.swift
//
//
//  Created by Guido Kühn on 05.05.23.
//

import XCTest

final class DataStoreTests: XCTestCase {
    func serialize(doc: Document)  {
        let dataA = try! JSONEncoder().encode(doc.$a.content)
        doc.$a.content = try! JSONDecoder().decode(AA.self, from: dataA)
        
        let dataB = try! JSONEncoder().encode(doc.$b.content)
        doc.$b.content = try! JSONDecoder().decode(BB.self, from: dataB)
    }

    func testInit() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        doc.add(a)
        serialize(doc: doc)

        let a1 = doc[AA.A.self, a.id]
        XCTAssertEqual(a1, a)
    }

    func testProperty() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        doc.add(a)
        a.a = "Hallo Welt"
        serialize(doc: doc)

        XCTAssertEqual(a.a, "Hallo Welt")

        let a1 = doc[AA.A.self, a.id]!
        XCTAssertEqual(a1.a, a.a)
    }

    func testObject() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        let b = BB.B()
        doc.add(a)
        doc.add(b)
        a.b = b
        serialize(doc: doc)

        XCTAssertNotNil(doc[BB.B.self, b.id])
        XCTAssertEqual(a.b, b)
    }

    func testReverse() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        let b = BB.B()
        doc.add(a)
        doc.add(b)
        a.b = b
        serialize(doc: doc)

        XCTAssertEqual(b.a, a)
    }
    
    func testReverses() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        let b = BB.B()
        b.c = a
        doc.add(a)
        
        serialize(doc: doc)

        XCTAssertEqual(b.c, a)
        XCTAssert(a.c.contains(b))
        XCTAssert(b.cc.contains(a))
    }

    func testAdopt() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        let b = BB.B()
        a.b = b
        doc.add(a)
        XCTAssertNotNil(doc[BB.B.self, b.id])
        serialize(doc: doc)
        XCTAssertNotNil(doc[BB.B.self, b.id])

    }
}
