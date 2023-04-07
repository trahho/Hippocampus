//
//  Data.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

class Information: PersistentGraph<Structure.Role.ID, Structure.Aspect.ID> {
    
    func createNode(roles: [Structure.Role] = [], timestamp: Date? = nil) -> Node {
        let timestamp = timestamp ?? Date()
        let node = Node()
        node[Date.self, Structure.Role.global.created.id, timestamp: timestamp] = timestamp
        roles.forEach { node[role: $0, timestamp: timestamp] = true }
        add(node, timestamp: timestamp)
        return node
    }
}


