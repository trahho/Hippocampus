//
//  Structure.Query.Predicate.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

extension Presentation {
    class Predicate: Object {
        static func == (lhs: Predicate, rhs: Predicate) -> Bool {
            lhs.condition == rhs.condition && lhs.roleIds == rhs.roleIds
        }

        @Persistent var condition: Information.Condition
        @Persistent private var roleIds: Set<Structure.Role.ID>
        
        var roles: Set<Structure.Role> {
            get {
                base.roles(roleIds: roleIds)
            }
            set {
                roleIds = base.roles(roles: newValue)
            }
        }

        func matches(for member: Information.Item) -> Bool {
            condition.matches(for: member)
        }
    }
}
