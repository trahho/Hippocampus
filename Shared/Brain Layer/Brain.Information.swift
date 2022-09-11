//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Information: PersistentObject, ObservableObject, AspectStorage {
        @PublishedSerialized private(set) var perspectives: Set<Perspective.ID> = []
        @PublishedSerialized private(set) var aspects: [Aspect.ID: Codable] = [:]

        required init() {}

        func takesPerspective(_ id: Perspective.ID) -> Bool {
            perspectives.contains(id)
        }

        subscript(_ key: Aspect.ID) -> Codable? {
            get {
                aspects[key]
            }
            set {
                aspects[key] = newValue
            }
        }
    }
}
