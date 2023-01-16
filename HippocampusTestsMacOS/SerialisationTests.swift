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
