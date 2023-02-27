//
//  Structure.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

class Structure: PersistentObjectGraph {
    @Present var queries: Set<Query>
    @Present var roles: Set<Role>

    override func setup() -> Structure {
        let roles: [Role] = [.global, .drawing, .topic, .note]
        roles.forEach { add($0, timestamp: Date.distantPast) }
        
        [Query.notes]
            .forEach { add($0, timestamp: Date.distantPast) }
        assert(Role.global.graph != nil)
        return self
    }
}
