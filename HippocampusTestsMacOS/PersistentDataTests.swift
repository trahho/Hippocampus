//
//  PersistentDataTests.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 28.04.23.
//

import XCTest

final class PersistentDataTests: XCTestCase {
    class TestData: PersistentData {
        @Storage var items: Set<TestItem>

        var otherData: OtherData?
    }

    class TestItem: PersistentData.Object {}

    class OtherData: PersistentData {
        @Storage var items: Set<OtherItem>
    }

    class OtherItem: PersistentData.Object {}

    func testStorage() throws {
        let data = TestData()
        let item = TestItem()
        data.add(item: item)
        let storedItem = data[TestItem.self, item.id]
        XCTAssertNotNil(storedItem)
        XCTAssertNotNil(storedItem?.data)
    }

    func testStorageSerialization() throws {
        let data = TestData()
        let item = TestItem()
        data.add(item: item)

        let json = data.encode()
        XCTAssertNotNil(json)

        let newData = TestData.decode(persistentData: json!)
        newData?.restore(content: nil)
        XCTAssertNotNil(newData)

        let newItem = newData![TestItem.self, item.id]
        XCTAssertNotNil(newItem)
        XCTAssertNotNil(newItem?.data)
    }

    func testMerging() throws {
        let data = TestData()
        let item = TestItem()
        data.add(item: item)

        let newData = TestData()

        try! newData.merge(other: data)
        let newItem = newData[TestItem.self, item.id]
        XCTAssertNotNil(newItem)
        XCTAssertNotNil(newItem?.data)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
