//
//  DataStoreTests.swift
//
//
//  Created by Guido Kühn on 05.05.23.
//

import XCTest

final class DataStoreTests: XCTestCase {
    func testInit() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        doc.add(a)

        let a1 = doc[AA.A.self, a.id]
        XCTAssertEqual(a1, a)
    }

    func testProperty() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        doc.add(a)
        a.a = "Hallo Welt"
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

        XCTAssertEqual(b.a, a)
    }
    
    func testAdopt() throws {
        let doc = Document(url: .virtual)
        let a = AA.A()
        let b = BB.B()
        a.b = b
        doc.add(a)

        XCTAssertNotNil(doc[BB.B.self, b.id])
    }
}
