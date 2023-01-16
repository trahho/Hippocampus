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

    func testRoleCondition() throws {
        let condition = PersistentData.Condition.hasRole(role: "Hallo")
        if case let .hasRole(role) = condition {
            XCTAssert(role == "Hallo")
        }
    }

    func testRoleSet() throws {
        let data = TestData()
        data[role: "Test"] = true
        data[role: "Hallo"] = true
        data.text = "Hallo Welt"
        XCTAssert(data[role: "Test"] == true)
        XCTAssert(data[role: "Hallo"] == true)
        XCTAssert(data.text == "Hallo Welt")

        var newdata = TestData()
        newdata.id = data.id
        newdata.merge(other: data)
        XCTAssert(newdata[role: "Test"] == true)
        XCTAssert(newdata[role: "Hallo"] == true)
        XCTAssert(newdata.text == "Hallo Welt")

        let flattened = try! CyclicEncoder().flatten(data)
        let flattenedjson = try! JSONEncoder().encode(flattened)
        let json = try! JSONEncoder().encode(data)
        print(String(data: json, encoding: .utf8))
        let decodedflattenedjson = try! JSONDecoder().decode(FlattenedContainer.self, from: flattenedjson)
        let decodedflattened = try! CyclicDecoder().decode(TestData.self, from: decodedflattenedjson)
        let decodedjson = try! JSONDecoder().decode(TestData.self, from: json)

        newdata = decodedflattened

        XCTAssert(newdata[role: "Test"] == true)
        XCTAssert(newdata[role: "Hallo"] == true)
        XCTAssert(newdata.text == "Hallo Welt")
    }

    class TestStorage: Codable {
        var _value: (any PersistentData.PersistentValue)?
        var container: SingleValueDecodingContainer?
        var _isSet = false

        subscript<T: PersistentData.PersistentValue>(_: T.Type) -> T? {
            get {
                if _value == nil, !_isSet, let container {
                    _value = try? container.decode(T.self)
                    _isSet = true
                }
                return _value as? T
            }
            set {
                _value = newValue
                _isSet = true
            }
        }

        init() {}

        required init(from decoder: Decoder) throws {
            container = try decoder.singleValueContainer()
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            if let _value {
                try container.encode(_value)
            } else {
                try container.encodeNil()
            }
        }
    }

    func testCodingString() throws {
        var x = TestStorage()
        x[String.self] = "Hallo Welt"

        XCTAssert(x[String.self] == "Hallo Welt")

        let json = try! JSONEncoder().encode(x)
        print(json)
        var y = try! JSONDecoder().decode(TestStorage.self, from: json)

        XCTAssert(y[String.self] == x[String.self])
    }

    func testCodingNil() throws {
        var x = TestStorage()
        x[String.self] = nil

        XCTAssert(x[String.self] == nil)

        let json = try! JSONEncoder().encode(x)
        print(json)
        var y = try! JSONDecoder().decode(TestStorage.self, from: json)

        XCTAssert(y[String.self] == x[String.self])
    }

    class TestClass: Codable {
        var x = "Hallo"
    }

//    func testClassFromString() throws {
//        var x = TestClass()
//        var name = x.typeName
//        let y =  NSClassFromString(name)!.init()
    ////        let classe: AnyClass = NSClassFromString(name)!
    ////        let y = classe.init()
//
//    }

//    enum DecoderStorage {
//        enum Keys: String, CodingKey {
//            case type, value
//        }
//
//        typealias Initializer = () -> Any
//        static var dict: [String: Initializer] = [:]
//
//        static func register<T>(_ type: T.Type) {
//            let name = String(reflecting: T.self)
//            self.dict[name] = { T.init()}
//        }
//    }
//
//    class AnyCodable: Codable {
//        var value: any PersistentData.PersistentValue
//        var typ: String
//
//        init<T: PersistentData.PersistentValue>(value: T?) {
//            self.typ = value.typeName
//            self.value = value
//        }
//
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: DecoderStorage.Keys.self)
//            try container.encode(self.typ, forKey: .type)
//            try container.encode(self.value, forKey: .value)
//        }
//
//        required init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: DecoderStorage.Keys.self)
//            self.typ = try container.decode(String.self, forKey: .type)
//            let initializer = DecoderStorage.dict[self.typ]!
//            self.value = initializer(container)
//        }
//    }
//
//    func testEncode() throws {
//        DecoderStorage.register(String.self)
//        DecoderStorage.register(Structure.Aspect.Representation.self)
//        DecoderStorage.register(Set<String>.self)
//        var x = AnyCodable(value: "Hallo Welt")
//        var y = AnyCodable(value: Structure.Aspect.Representation.date)
//        var z = AnyCodable(value: Set<String>())
//        var encoder = JSONEncoder()
//        let json = try! encoder.encode(x)
//        let result = JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
//    }

//    func testEncode() throws {
//
//        var data: Codable
//
//
//        let flattened = try! CyclicEncoder().flatten(data)
//        let flattenedjson = try! JSONEncoder().encode(flattened)
//        let json = try! JSONEncoder().encode(data)
//        print(String(data: json, encoding: .utf8))
//        let decodedflattenedjson = try! JSONDecoder().decode(FlattenedContainer.self, from: flattenedjson)
//        let decodedflattened = try! CyclicDecoder().decode(TestData.self, from: decodedflattenedjson)
//        let decodedjson = try! JSONDecoder().decode(TestData.self, from: json)
//
//        newdata = decodedjson
//
//        XCTAssert(newdata[role: "Test"] == true)
//        XCTAssert(newdata[role: "Hallo"] == true)
//        XCTAssert(newdata.text == "Hallo Welt")
//    }

    func testComparison() throws {
        let data = TestData()
        data.text = "Hallo Welt"
        let predicate = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key: "text", value: "Hallo Welt", condition: .equal))
        let predicate2 = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key: "text", value: "Hallo Wet", condition: .equal))
        let predicate3 = PersistentData.Condition.hasValue(PersistentData.Condition.Comparison(key: "text", value: "", condition: .above))

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
