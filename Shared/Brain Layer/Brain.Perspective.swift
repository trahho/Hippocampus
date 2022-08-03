//
//  Brain.Perspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Perspective: Serializable {
        @Serialized var designation: String = ""
        @Serialized var aspects: [Aspect]

        required init() {}
    }
}

extension Brain.Perspective: Identifiable, Hashable {
    static func == (lhs: Brain.Perspective, rhs: Brain.Perspective) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// TODO: Collection von Frames, welche die Perspektiven repräsentieren können. Frame kann einen davon wählen. Über Id.
