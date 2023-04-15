//
//  Document.Presentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation

class Presentation: PersistentData<Presentation.Storage> {
    @Observed var structure: Structure

    func role(id: Structure.Role.ID) -> Structure.Role {
        structure[id]!
    }

    func roles(roleIds: Set<Structure.Role.ID>) -> Set<Structure.Role> {
        roleIds.compactMap { role(id: $0) }.asSet
    }

    func roles(roles: Set<Structure.Role>) -> Set<Structure.Role.ID> {
        roles.map { $0.id }.asSet
    }

    @Present var queries: Set<Query>

    override func setup() -> Presentation {
        let queries: [Query] = [.notes, .topics]
        queries.forEach {
            add($0, timestamp: Date.distantPast)
            $0.isStatic = true
        }
        return self
    }
}
