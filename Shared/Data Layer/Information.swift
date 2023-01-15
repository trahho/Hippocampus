//
//  Data.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

class Information: PersistentGraph<Structure.Role.ID, Structure.Aspect.ID> {
    func createNode(roles: [Structure.Role] = [], timestamp: Date? = Date()) -> Node {
        let node = Node()
        add(node, timestamp: timestamp)
        roles.forEach { node[role: $0.id, timestamp: timestamp] = true }
        return node
    }
}

extension Information.Item {
    subscript(role: Structure.Role, timestamp: Date? = nil) -> Bool {
        get {
            self[role: role.id, timestamp: timestamp]
        }
        set {
            self[role: role.id, timestamp: timestamp] = newValue
        }
    }

    subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect, timestamp: Date? = nil) -> T? where T: Information.PersistentValue {
        get {
            self[type, aspect.id, timestamp: timestamp]
        }
        set {
            let timestamp = timestamp ?? Date()
            self[type, aspect.id, timestamp: timestamp] = newValue
            self[role: aspect.role.id, timestamp: timestamp] = true
        }
    }
}
