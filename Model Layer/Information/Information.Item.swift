//
//  Information.Item+subscripts.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.01.23.
//

import Foundation

extension Information {
    class Item: Object {
        @Property var deleted: Bool
        @Objects var roles: Set<Structure.Role>

        @Objects var to: Set<Item>
        @References(\Item.to) var from: Set<Item>

        subscript(role role: Structure.Role) -> Bool {
            get {
                roles.contains(role)
            }
            set {
                if newValue == true {
                    let allRoles = role.allRoles
                    if !roles.isSuperset(of: allRoles) {
                        roles = roles.union(allRoles)
                    }
                } else {
                    roles.remove(role)
                }
            }
        }

        subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect) -> T? where T: Information.PersistentValue {
            get {
                self[type, aspect.id.key]
            }
            set {
                self[type, aspect.id.key] = newValue
                self[role: aspect.role] = true
            }
        }
    }
}
