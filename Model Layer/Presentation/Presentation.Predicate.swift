//
//  Structure.Query.Predicate.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

extension Presentation {
    class Predicate: Object {
        @Persistent var condition: Information.Condition
        @Persistent private var roleIds: Set<Structure.Role.ID>

        var roles: Set<Structure.Role> {
            get {
                base.roles(roleIds: roleIds)
            }
            set {
                roleIds = newValue.map { $0.id }.asSet
            }
        }

        func matches(for member: Information.Item) -> Bool {
            condition.matches(for: member)
        }
    }
}
