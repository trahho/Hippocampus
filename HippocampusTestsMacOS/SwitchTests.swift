//
//  SwitchTests.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 30.06.24.
//

import XCTest

final class SwitchTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTuple() throws {
        let one = 1
        let two = 2

        switch (one, two) {
        case (1, _):
            print("one first")
        case (_, 2):
            print("two last")
        case (1, 2):
            print("match")
        default:
            print("default")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
