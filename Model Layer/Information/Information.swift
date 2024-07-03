//
//  Data.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

class Information: ObjectStore {
    typealias ValueStorage = Information.TimedValue.ValueStorage
    typealias Value = ValueStorage.PersistentValue
    
    @Objects var items: Set<Item>

//    var items: Set<Item> {
//        allItems.filter { !$0.deleted }.asSet
//    }
//

//    func createNode(roles: [Structure.Role] = [], timestamp: Date? = nil) -> Node {
//        let timestamp = timestamp ?? Date()
//        let node = Node()
//        node[Date.self, Structure.Role.global.created.id, timestamp: timestamp] = timestamp
//        roles.forEach { node[role: $0, timestamp: timestamp] = true }
//        add(node, timestamp: timestamp)
//        return node
//    }
}
