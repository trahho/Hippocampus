////
////  PropertyWrapperTests.swift
////  HippocampusTestsMacOS
////
////  Created by Guido Kühn on 25.04.23.
////
//
//import XCTest
//
//final class PropertyWrapperTests: XCTestCase {
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    class A: Presentation.Object {
//        @Relation var b: B?
//        @Relations var bb: Set<B>
//    }
//
//    class B: Presentation.Object {
//        @Relation var a: A?
//    }
//    
//    func testRelationWithoutGraph() throws {
//        let a = A()
//        let b = B()
//        a.b = b
//        XCTAssert(a.b == b)
//    }
//    
//    func testRelationWithGraph() throws {
//        let presentation = Presentation()
//        let a = A()
//        let b = B()
//        presentation.add(a)
//        presentation.add(b)
//        a.b = b
//        XCTAssert(a.b == b)
//    }
//    
//    func testSerialization() throws {
//        let presentation = Presentation()
//        let group = Presentation.Group()
//        presentation.add(group)
//        
//        XCTAssertNotNil(presentation.nodeStorage[group.id] as? Presentation.Group)
//        
//        let data = try? JSONEncoder().encode(presentation)
//        XCTAssertNotNil(data)
//        print(data!)
//        let decodedPresentation = try? JSONDecoder().decode(Presentation.self, from: data!)
//        XCTAssertNotNil(decodedPresentation)
//        XCTAssertNotNil(decodedPresentation!.nodeStorage[group.id])
//        XCTAssertNotNil(decodedPresentation!.nodeStorage[group.id] as? Presentation.Group)
//
////        XCTAssertNotNil(<#T##expression: Any?##Any?#>)
//    }
//    
//    func testRelationWithSerializedGraph() throws {
//        let presentation = Presentation()
//        let a = A()
//        let b = B()
//        a.b = b
//        presentation.add(a)
//        presentation.add(b)
//        let data = presentation.encode()
//        XCTAssertNotNil(data)
//        let decodedPresentation = Presentation.decode(persistentData: data!)
//        XCTAssertNotNil(decodedPresentation)
//        XCTAssertNotNil(decodedPresentation?.nodeStorage[a.id])
//        let decodedA: A = decodedPresentation![a.id]!
//        let decodedB: B = decodedPresentation![b.id]!
//        XCTAssert(decodedA[B.ID.self, "b"] == b.id)
//        XCTAssert(decodedA.b == decodedB)
//    }
//    
//    func testRelationsWithoutGraph() throws {
//        let a = A()
//        let b1 = B()
//        let b2 = B()
//        a.bb = [b1, b2]
//        XCTAssert(a.bb == [b1, b2])
//    }
//    
//    func testRelationsWithGraph() throws {
//        let presentation = Presentation()
//        let a = A()
//        let b1 = B()
//        let b2 = B()
//        a.bb = [b1, b2]
//        presentation.add(a)
//        presentation.add(b1)
//        presentation.add(b2)
//        XCTAssertNotNil(b1.graph)
//        XCTAssert(a.bb == [b1, b2])
//    }
//    
//    func testRelationsWithSerializedGraph() throws {
//        let presentation = Presentation()
//        let a = A()
//        let b1 = B()
//        let b2 = B()
//        
//        a.bb = [b1, b2]
//        presentation.add(a)
//        presentation.add(b1)
//        presentation.add(b2)
//        XCTAssertNotNil(b1.graph)
//        
//        let data = presentation.encode()
//        XCTAssertNotNil(data)
//        let decodedPresentation = Presentation.decode(persistentData: data!)!
//        XCTAssertNotNil(data)
//        
//        let decodedA: A = decodedPresentation[a.id]!
//        let decodedB: B = decodedPresentation[b1.id]!
////        XCTAssert(decodedA[B.ID.self, "b"]. == bId)
//        XCTAssert(decodedA.bb.contains(decodedB))
//    }
//}
