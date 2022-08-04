//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Information: Serializable, Identifiable {
//        @Serialized var id: UUID = .init()
        @Serialized var perspectives: Set<Perspective> = []
        @Serialized var aspects: [Aspect : Codable]
        
        required init() {}
    }
}
