//
//  Data.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

class Information: PersistentGraph<Structure.Role.ID, Structure.Aspect.ID> {
    func createNode(roles: [Structure.Role] = []) -> Node {
        let node = Node()
        add(node)
        roles.forEach { node[role: $0.id] = true }
        return node
    }
}

extension Information.Item {
    subscript(role: Structure.Role) -> Bool {
        get { self[role: role.id] }
        set { self[role: role.id] = newValue }
    }

    subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect) -> T? where T: Information.PersistentValue {
        get {
            self[type, aspect.id]
        }
        set {
            let change = {
                self[type, aspect.id] = newValue
                self[role: aspect.role.id] = true
            }
            if let graph {
                graph.change(change)
            } else {
                change()
            }
        }
    }
}
