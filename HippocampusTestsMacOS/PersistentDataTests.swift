//
//  PersistentDataTests.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 16.12.22.
//

import XCTest

final class PersistentDataTests: XCTestCase {
    class TestData: PersistentData.Object {
        @Persistent var text: String
        @Relation(inverse: "data") var target: TestTarget?
        @Relation(inverse: "datas") var targets: TestTarget?
    }

    class TestTarget: PersistentData.Object {
        @Relation(inverse: "target") var data: TestData?
        @Relations(inverse: "targets") var datas: Set<TestData>
    }

    func testValue() throws {
        let data = TestData()
        data.text = "Hallo Welt"
        XCTAssert(data.text == "Hallo Welt")
        print("juhu")
    }

    func testComparison() throws {
        let data = TestData()
        data.text = "Hallo Welt"
        let predicate = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key:"text", value: "Hallo Welt", condition: .equal ))
        let predicate2 = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key:"text", value: "Hallo Wet", condition: .equal ))
        let predicate3 = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key:"text", value: "", condition: .above ))

        XCTAssert(predicate.matches(for: data))
        XCTAssert(!predicate2.matches(for: data))
        XCTAssert(predicate3.matches(for: data))

        print("juhu")
    }
    
    func testPredicate() throws {
        let predicate1 = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key: "text", value: "", condition: .above))
        let predicate2 = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key: "text", value: "", condition: .above))
        let predicate3 = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key: "text", value: "a", condition: .above))

        XCTAssert(predicate1 == predicate2)
        XCTAssert(predicate2 != predicate3)
        print("juhu")
    }

    func testRelation() throws {
        let data = TestData()
        let target = TestTarget()
        data.target = target
        XCTAssert(data.target == target)
        XCTAssert(target.data == data)
        print("juhu")
    }

    func testRelations() throws {
        let data1 = TestData()
        let data2 = TestData()
        let data3 = TestData()
        let target = TestTarget()
        target.datas = [data1, data2, data3]
        XCTAssert(target.datas.count == 3)
        XCTAssert(target.datas.contains(data1))
        XCTAssert(target.datas.contains(data2))
        XCTAssert(target.datas.contains(data3))
        XCTAssert(data1.targets == target)
        XCTAssert(data2.targets == target)
        XCTAssert(data3.targets == target)

        print("juhu")
    }
}
