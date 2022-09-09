//
//  Brain.Perspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

@dynamicMemberLookup
class Perspective: PersistentObject {
    static let perspectives = buildPerspectives {
        Perspective("Hallo") {
            Aspect("Welt", .text)
            Aspect("Sonnenuntergang", .drawing)
        }
    }

    static subscript(dynamicMember designation: String) -> Perspective.ID {
        perspectives.values.first { $0.designation == designation }!.id
    }

    subscript(dynamicMember designation: String) -> Aspect.ID {
        aspects.first { $0.designation == designation }!.id
    }

    @Serialized var designation: String = ""
    @Serialized var aspects: [Aspect]

    required init() {}

    init(_ designation: String, @Aspect.Builder aspects: () -> [Aspect]) {
        super.init()
        self.designation = designation
        self.aspects = aspects()
    }
}

// TODO: Collection von Frames, welche die Perspektiven repräsentieren können. Frame kann einen davon wählen. Über Id.
