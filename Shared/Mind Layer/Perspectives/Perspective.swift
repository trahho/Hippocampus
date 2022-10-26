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
        Perspective("Zeichnung") {
            Aspect("Zeichnung", .drawing)
        }
        Perspective("Thema", [Perspective.global]) {}
        Perspective("Notiz", [Perspective.global, Perspective.zeichnung]) {
            Aspect("Titel", .text)
            Aspect("Text", .text)
        }
    }

    static subscript(dynamicMember designation: String) -> Perspective {
        perspectives.values.first { $0.designation.lowercased() == designation.lowercased() }!
    }

    subscript(dynamicMember designation: String) -> Aspect {
        self[designation]!
    }

    subscript(_ designation: String) -> Aspect? {
        aspects.first(where: { $0.designation.lowercased() == designation.lowercased() }) ?? higherPerspectives.compactMap { $0[designation] }.first
    }

    typealias PerspectiveBuilder = () -> [Perspective]

    @Serialized var designation: String = ""
    @Serialized var aspects: [Aspect]
    @Serialized var perspectives: [Perspective] = []
    var perspectivesBuilder: PerspectiveBuilder

    var higherPerspectives: [Perspective] {
        perspectives + perspectivesBuilder()
    }

    func addAspect(_ aspect: Aspect) {
        aspect.id = aspects.map { $0.id }.max() ?? 2
        aspect.perspective = self
        aspects.append(aspect)
    }

    required init() {
        self.perspectivesBuilder = [Perspective].init
        super.init()
    }

    init(_ designation: String, _ perspectivesBuilder: @autoclosure @escaping PerspectiveBuilder = [Perspective](), @Aspect.Builder aspects: () -> [Aspect]) {
        self.perspectivesBuilder = perspectivesBuilder
        super.init()
        self.designation = designation
        self.aspects = aspects()
    }
}

// TODO: Collection von Frames, welche die Perspektiven repräsentieren können. Frame kann einen davon wählen. Über Id.
