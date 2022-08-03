//
//  Brain.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Aspect: Serializable {
        @Serialized var designation: String = ""
        @Serialized var representation: Representation

        required init() {}
    }
}

extension Brain.Aspect {
    enum Representation {
        case text, drawing
    }
}

extension Brain.Aspect: Identifiable, Hashable {
    static func == (lhs: Brain.Aspect, rhs: Brain.Aspect) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// TODO: Collection von Frames, welche die Werte repräsentieren können. Frame kann einen davon wählen. Über Id.
