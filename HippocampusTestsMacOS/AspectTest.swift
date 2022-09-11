//
//  AspectTest.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 11.09.22.
//

import XCTest

final class AspectTest: XCTestCase {
    func testCompareInt() throws {
        let a = 1
        let b = 1
        let result = Aspect.compareValues(lhs: a, rhs: b)
        XCTAssert(result == .equal, "Not compared")
    }
}
