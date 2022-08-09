//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Information: PersistentObject {
        @PublishedSerialized private(set) var perspectives: Set<Perspective.ID> = []
        @PublishedSerialized private(set) var aspects: [Aspect.ID: Codable] = [:]

        subscript(_ aspectId: Aspect.ID) -> Codable? {
            get {
                aspects[aspectId]
            }
            set {
                aspects[aspectId] = newValue
            }
        }

        required init() {}
    }
}
