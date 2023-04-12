//
//  Document.Presentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation

class Presentation: PersistentData<Presentation.Storage> {
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
