//
//  PropertyWrapperTests.swift
//  HippocampusTestsMacOS
//
//  Created by Guido Kühn on 25.04.23.
//

import XCTest

final class PropertyWrapperTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    class A: Presentation.Object {
        @Presentation.Relation1(reverse: \B.$a) var b: B?
    }

    class B: Presentation.Object {
        @Presentation.Relation1 var a: A?
    }
}
