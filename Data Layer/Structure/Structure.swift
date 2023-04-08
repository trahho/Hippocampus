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

    var aspects: [Aspect.ID: Aspect] {
        roles.filter { !$0.aspects.isEmpty }
            .flatMap { $0.aspects }
            .asDictionary(key: \.id)
    }

    override func setup() -> Structure {
        let roles: [Role] = [.global, .drawing, .text, .topic, .note]
        roles.forEach {
            add($0, timestamp: Date.distantPast)
            $0.isStatic = true
        }

        let queries: [Query] = [.notes, .topics]
        queries.forEach {
            add($0, timestamp: Date.distantPast)
            $0.isStatic = true
        }
        assert(Role.global.graph != nil)
        return self
    }
}
