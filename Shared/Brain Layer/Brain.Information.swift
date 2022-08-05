//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Information: Serializable, ObservableObject, IdentifiableObject {
        typealias ID = Int64

        @Serialized var id: ID = 0

        @PublishedSerialized private(set) var perspectives: Set<Perspective> = []
        @PublishedSerialized private(set) var aspects: [Aspect.ID: Codable] = [:]
        
        required init() {}
    }
}
