//
//  Data.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

class Information: PersistentGraph<Structure.Role.ID, Structure.Aspect.ID> {
    func createNode(roles: [Structure.Role] = [], changeManager: ChangeManager) -> Node {
        let node = Node()
        add(node, changeManager: changeManager)
        roles.forEach { node[role: $0.id, changeManager] = true }
        return node
    }
}

extension Information.Item {
    subscript(role: Structure.Role, changeManager: Information.ChangeManager? = nil) -> Bool {
        get {
            self[role: role.id]
        }
        set {
            self[role: role.id, changeManager] = newValue
        }
    }

    subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect, changeManager: Information.ChangeManager? = nil) -> T? where T: Information.PersistentValue {
        get {
            self[type, aspect.id]
        }
        set {
            let changeManager = changeManager ?? graph.changeManager()
            changeManager.action {
                self[type, aspect.id] = newValue
                self[role: aspect.role.id] = true
            }
        }
    }
}
