//
//  Structure.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

class Structure: PersistentData {
    @Present var queries: Set<Query>
    @Present var roles: Set<Role>

    override func setup() -> Structure {
        [Role.global, Role.drawing, Role.topic, Role.note]
            .forEach { add($0, timestamp: Date.distantPast) }
        [Query.notes]
            .forEach { add($0, timestamp: Date.distantPast) }
        assert(Role.global.graph != nil)
        return self
    }
}
