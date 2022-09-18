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
        Perspective("Global") {
            Aspect("Name", .text)
        }
        Perspective("Thema") {
            Aspect("Name", .text)
        }
        Perspective("Notiz") {
            Aspect("Name", .text)
            Aspect("Text", .text)
            Aspect("Zeichnung", .drawing)
        }
    }

    static subscript(dynamicMember designation: String) -> Perspective {
        perspectives.values.first { $0.designation.lowercased() == designation.lowercased() }!
    }

    subscript(dynamicMember designation: String) -> Aspect {
        aspects.first { $0.designation.lowercased() == designation.lowercased() }!
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
