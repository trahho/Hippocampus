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
    
    func testRelation() throws {
        typealias Group = Presentation.Group
        let document = HippocampusApp.previewDocument()
        let group1 = Group()
        let group2 = Group()
        print("Add")
        document.presentation.add(group1)
        document.presentation.add(group2)
        group1.subGroups.insert(group2)
        
        let edges = document.presentation.edges.count
        
        XCTAssert(group2.superGroups.count == 1)
        XCTAssert(group1.subGroups.count == 1)
        XCTAssert(group2.superGroups.contains(group1))
        XCTAssert(group1.subGroups.contains(group2))
        XCTAssert(!group2.isTop)
        XCTAssert(group1.isTop)

        print("Remove")
        group1.subGroups.remove(group2)
        XCTAssert(group2.superGroups.count == 0)
        XCTAssert(group1.subGroups.count == 0)
        XCTAssert(!group2.superGroups.contains(group1))
        XCTAssert(!group1.subGroups.contains(group2))
        XCTAssert(group2.isTop)
        XCTAssert(group1.isTop)
        
        XCTAssert(edges == document.presentation.edges.count + 1)
    }
    
    func testSerialization() throws {
        let store = Information()
        let node1 = Information.Node()
        let node2 = Information.Node()
        let edge = Information.Edge(from: node1, to: node2)
        store.add(edge)
        
        let data = try? CyclicEncoder().flatten(store)
        XCTAssertNotNil(data)
    }
    
    func testSerializationMergeEdges() throws {
        let store = Information()
        let node1 = Information.Node()
        let node2 = Information.Node()
        let edge = Information.Edge(from: node1, to: node2)
        let role1 = UUID()
        let role2 = UUID()
        edge[role: role1,timestamp: Date()] = true
        store.add(edge)
        
        XCTAssert(store.nodeStorage.count == 2)
        XCTAssert(store.edgeStorage.count == 1)
        
        let edge2 = Information.Edge(from: node1, to: node2)
        edge2[role: role2,timestamp: Date()] = true
        let result = store.add(edge2)
        
        XCTAssert(store.nodeStorage.count == 2)
        XCTAssert(store.edgeStorage.count == 1)
        
        XCTAssert(result[role: role1] == true)
        XCTAssert(result[role: role2] == true)
    }
    
    func testSerializationPresentation() throws {
        let store = Presentation()
        let node1 = Presentation.Group()
        let node2 = Presentation.Group()
        node1.subGroups.insert(node2)
        store.add(node1)
        XCTAssert(store.nodeStorage.count == 2)
        XCTAssert(store.edgeStorage.count == 1)
        XCTAssert(node1.subGroups.contains(node2))
        let data = try? CyclicEncoder().flatten(store)
        XCTAssertNotNil(data)
    }
    
    func testSerializationStructure() throws {
        let store = Structure()
        let node1 = Structure.Role()
        let node2 = Structure.Aspect()
        node2.role = node1
        store.add(node1)
        XCTAssert(store.nodeStorage.count == 2)
        XCTAssert(store.edgeStorage.count == 1)
        let data = try? CyclicEncoder().flatten(store)
        XCTAssertNotNil(data)
    }
    
    func testSerializationStructure2() throws {
        let store = Structure()
        let node1 = Structure.Role()
        let node2 = Structure.Aspect()
        let node3 = Structure.Aspect()

//        node2.role = node1
//        node3.role = node1
        let edge1 = Structure.Edge(from: node2, to: node1)
        let edge2 = Structure.Edge(from: node3, to: node1)
        
        store.add(node1)
        XCTAssert(store.nodeStorage.count == 3)
        XCTAssert(store.edgeStorage.count == 2)
        let data = try! CyclicEncoder().flatten(store)
        XCTAssertNotNil(data)
    }
    
//    func testCombinedData() throws {
    ////        let value1 = 42
    ////        let value2 = "Gerhart-Hauptmann-Straße"
    ////        var data = Data()
    ////        withUnsafeBytes(of: value1) { bytes in
    ////            data.append(contentsOf: bytes)
    ////        }
    ////        let data1  = value1.description.data(using: .utf8)
    ////        let length = data.count
    ////        let data2 = value2.data(using: .utf8)
    ////        data.append(contentsOf: data1)
    ////        data.append(contentsOf: data2)
    ////
    ////        let result1 = data.
//    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
