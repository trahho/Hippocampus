//
//  DatabaseDocumentTests.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 30.04.23.
//

import XCTest

final class DatabaseDocumentTests: XCTestCase {
    class Database: PersistentData {
        
        @Storage var items: Set<Item>
        
        class Item: Object {}
    }

    class Database2: PersistentData {
        @Storage var items: Set<Item>

        class Item: Object {}
    }

    class Document: DatabaseDocument {
        @Data var base = Database()
        @Data var base2 = Database()
    }

    func testSetup() throws {
        let doc = Document(url: URL.virtual)
        XCTAssertNotNil(doc.base)
        XCTAssert(doc.base.document === doc)
        XCTAssertNotNil(doc.base2)
        XCTAssert(doc.base2.document === doc)
    }

    func testStorage() throws {
        let doc = Document(url: URL.virtual)
        let item = Database.Item()
        doc.base.add(item: item)
        XCTAssertEqual(doc.base[Database.Item.self, item.id], item)
        XCTAssertEqual(doc.base2[Database.Item.self, item.id], item)
        XCTAssertNil(doc[Database2.Item.self, UUID()])
    }
}
