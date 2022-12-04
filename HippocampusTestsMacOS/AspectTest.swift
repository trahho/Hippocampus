//
//  AspectTest.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 11.09.22.
//

import XCTest

//final class AspectTest: XCTestCase {
//    func testCompareInt() throws {
//        let a = 1
//        let b = 1
//        let result = Aspect.compareValues(lhs: a, rhs: b)
//        XCTAssert(result == .equal, "Not compared")
//    }
//}

//final class JSONTest: XCTestCase {
//    struct Test: Codable {
//        var data: Codable?
//        
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            let code = try? data?.encode(to: encoder) == nil
//            try! container.encode(code)
//        }
//        
//        init(from decoder: Decoder) throws {
//            var container = decoder.singleValueContainer()
//            let code = try! container.decode(<#T##type: Bool.Type##Bool.Type#>)
//        }
//    }
//}

final class PersistentText: XCTestCase {
    class Item: PersistentData.Object {
        @Persistent var test: String = ""
    }
    
    func testInitObject() throws {
        let test = Item()
        test.test = "Hallo Welt"
        XCTAssert(test.test == "Hallo Welt")
    }
    
    func testInitManyObjects() throws {
        let node = PersistentData.Node()
        let o1 = Item(node)
        let o2 = Item(node)
        o1.test = "Hallo Welt"
        XCTAssert(o2.test == "Hallo Welt")
        XCTAssert(o1 == o2)
    }
}
