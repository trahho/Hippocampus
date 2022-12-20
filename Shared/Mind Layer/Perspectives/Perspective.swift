//
//  Brain.Perspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

@dynamicMemberLookup
class Perspective: PersistentObject {
    subscript(dynamicMember designation: String) -> Aspect {
        self[designation]!
    }

    subscript(_ designation: String) -> Aspect? {
        aspects.first(where: { $0.designation.lowercased() == designation.lowercased() }) ?? higherPerspectives.compactMap { $0[designation] }.first
    }

    typealias PerspectiveReferences = () -> [Perspective]

    @Serialized var designation: String = ""
    @Serialized var aspects: [Aspect] = []
    @Serialized var perspectives: [Perspective] = []
    var perspectivesBuilder: PerspectiveReferences = [Perspective].init

    var higherPerspectives: [Perspective] {
        perspectives + perspectivesBuilder()
    }

    func addAspect(_ aspect: Aspect) {
        aspect.perspective = self
        aspects.append(aspect)
    }

    required init() {}

   
}

// TODO: Collection von Frames, welche die Perspektiven repräsentieren können. Frame kann einen davon wählen. Über Id.
