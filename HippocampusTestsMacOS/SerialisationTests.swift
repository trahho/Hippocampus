//
//  SerialisationTests.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 08.12.22.
//

import XCTest

// protocol Item {
//    var text: String {get set}
// }
//
//
//
// extension PersistentData.Object: Item {
//
// }
//
// final class SerialisationTests: XCTestCase {
//    class Source: PersistentObject {
//        @Serialized(reverse: \Target.source) var target: Target
//        @Serialized(reverse: \Target.sources) var collection: Target {
//            didSet {
//                collection.sources.insert(self)
//            }
//        }
//
//        required init() {}
//    }
//
//    class Target: PersistentObject {
//        var source: Source!
//
//        var sources: Set<Source> = []
//
//        required init() {}
//    }
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testSingleReference() throws {
//        let testObject = Source()
//        testObject.target = Target()
//
//        var flattened = try! CyclicEncoder().flatten(testObject)
//        var data = try! JSONEncoder().encode(flattened)
//        let compressedData = try! (data as NSData).compressed(using: .lzfse) as Data
//        data = try! (compressedData as NSData).decompressed(using: .lzfse) as Data
//        flattened = try! JSONDecoder().decode(FlattenedContainer.self, from: data)
//        let result = try! CyclicDecoder().decode(Source.self, from: flattened)
//
//        XCTAssert(result.target.source === result, "Not linked")
//    }
//
//
//
//    func testSetReference() throws {
//        let testObject = Target()
//        let a = Source()
//        a.collection = testObject
////        a.target = testObject
//        XCTAssert(a.collection.sources.contains(a))
//
//        var flattened = try! CyclicEncoder().flatten(a)
//        var data = try! JSONEncoder().encode(flattened)
//        let compressedData = try! (data as NSData).compressed(using: .lzfse) as Data
//        data = try! (compressedData as NSData).decompressed(using: .lzfse) as Data
//        flattened = try! JSONDecoder().decode(FlattenedContainer.self, from: data)
//        let result = try! CyclicDecoder().decode(Source.self, from: flattened)
//        XCTAssert(result.collection.sources.contains(result))
//    }
// }

final class SerialisationTests: XCTestCase {
    class B: Codable {
        var name: String
        
        init(name: String) {
            self.name = name
        }
    }

    class A: B {
        var value: Int
        
        init(name: String, value: Int) {
            self.value = value
            super.init(name: name)
        }
        
        private enum CodingKeys: String, CodingKey {
            case value
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try container.decode(Int.self, forKey: .value)
            try super.init(from: decoder)
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(value, forKey: .value)
            try super.encode(to: encoder)
        }
    }
    
    func testSubclasses() throws {
        let objects: [B] = [B(name: "Object 1"), A(name: "Object 2", value: 42)]
        let encoder = JSONEncoder()
        let data = try encoder.encode(objects)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedObjects = try decoder.decode([B].self, from: data)
        
        XCTAssert(decodedObjects[0] is B)
        XCTAssert(decodedObjects[1] is A)
    }
}
