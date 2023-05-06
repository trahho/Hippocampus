//
//  Structure.Query.Predicate.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

extension Presentation {
    class Predicate: Object {
        @Property var condition: Information.Condition
        @Objects var roles: Set<Structure.Role>

        func matches(for member: Information.Item) -> Bool {
            condition.matches(for: member)
        }
    }
}
