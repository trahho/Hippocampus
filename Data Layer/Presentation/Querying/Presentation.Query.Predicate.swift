//
//  Structure.Query.Predicate.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

extension Presentation.Query {
    struct Predicate: Presentation.PersistentValue, Serializable {
        static func == (lhs: Predicate, rhs: Predicate) -> Bool {
            lhs.condition == rhs.condition && lhs.roles == rhs.roles
        }

        @Serialized var condition: Information.Condition
        @Serialized var roles: Set<Structure.Role.ID>

        init() {}

//        init(condition: Information.Condition, roles: Set<Structure.Role.ID>) {
//            self.condition = condition
//            self.roles = roles
//        }

        func matches(for member: Information.Item) -> Bool {
            condition.matches(for: member)
        }

//        func roles(for member: Information.Item) -> Set<Structure.Role.ID> {
//            matches(for: member) ? roles : []
//        }
    }
}
