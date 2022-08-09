//
//  Brain.Perspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Perspective: PersistentObject {
        static let perspectives = buildPerspectives {
            Perspective("Hallo") {
                Aspect("Welt", .text)
                Aspect("Sonnenuntergang", .drawing)
            }
        }

        static subscript(_ designation: String) -> Perspective {
            perspectives.first { $0.designation == designation }!
        }

        subscript(_ designation: String) -> Aspect {
            aspects.first { $0.designation == designation }!
        }

        @Serialized var designation: String = ""
        @Serialized var aspects: [Aspect]

        required init() {}

        init(_ designation: String, @Brain.Aspect.Builder aspects: () -> [Aspect]) {
            super.init()
            self.designation = designation
            aspects = aspects()
        }
    }
}

// TODO: Collection von Frames, welche die Perspektiven repräsentieren können. Frame kann einen davon wählen. Über Id.
