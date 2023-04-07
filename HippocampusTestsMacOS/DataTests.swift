//
//  DataTests.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 27.02.23.
//

import XCTest

final class DataTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
    
    struct Test {
        var x = Set<Int>()
    }
    
    func testStruct() throws {
        var x = Test()
        x.x.insert(0)
        XCTAssert(x.x.contains(0))
    }

    func testCombinedData() throws {
//        let value1 = 42
//        let value2 = "Gerhart-Hauptmann-Straße"
//        var data = Data()
//        withUnsafeBytes(of: value1) { bytes in
//            data.append(contentsOf: bytes)
//        }
//        let data1  = value1.description.data(using: .utf8)
//        let length = data.count
//        let data2 = value2.data(using: .utf8)
//        data.append(contentsOf: data1)
//        data.append(contentsOf: data2)
//        
//        let result1 = data.
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
