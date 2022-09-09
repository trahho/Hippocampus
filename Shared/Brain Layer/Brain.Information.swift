//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Information: PersistentObject, AspectStorage {
        @PublishedSerialized private(set) var perspectives: Set<Perspective.ID> = []
        @PublishedSerialized private(set) var aspects: [Aspect.ID: Codable] = [:]

        required init() {}
        
        func setValue(_ key: Aspect.ID, value: Codable?) {
            aspects[key] = value
        }

        subscript(_ key: Aspect.ID) -> Codable? {
            get {
                aspects[key]
            }
            set {
                aspects[key] = newValue
            }
        }

        subscript(_ aspect: Aspect) -> Codable? {
            get {
                aspects[aspect.id]
            }
            set {
                aspects[aspect.id] = newValue
            }
        }
    }
}
