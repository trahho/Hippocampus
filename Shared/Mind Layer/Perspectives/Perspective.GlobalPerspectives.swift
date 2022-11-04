//
//  Perspective.GlobalPerspectives.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation

extension Perspective {
    enum GlobalPerspectives: Perspective.ID, CaseIterable {
        case global
        case drawing
        case topic
        case note
    }

    static let globalPerspectives = buildPerspectives {
        Perspective(.global, "Global") {
            Aspect("Name", .text)
        }
    }.addGroup("Basiselemente") {
        Perspective(.drawing, "Zeichnung") {
            Aspect("Zeichnung", .drawing)
        }
    }.addGroup("Notizen") {
        Perspective(.topic, "Thema", [Perspective.global]) {}
        Perspective(.note, "Notiz", [Perspective.global, Perspective.drawing]) {
            Aspect("Titel", .text)
            Aspect("Text", .text)
        }
    }

    static subscript(dynamicMember designation: String) -> Perspective {
        let perspectiveId = -GlobalPerspectives.from(string: designation.lowercased())!.rawValue
        return globalPerspectives.values.first { $0.id == perspectiveId }!
    }
    
    convenience init(_ id: GlobalPerspectives, _ designation: String, _ perspectivesBuilder: @autoclosure @escaping PerspectiveReferences = [Perspective](), @Aspect.Builder aspects: () -> [Aspect]) {
        self.init()
        self.perspectivesBuilder = perspectivesBuilder
        self.id = -id.rawValue
        self.designation = designation
        let globalAspects = [Aspect("Created", .date), Aspect("Modified", .date)]
        self.aspects = globalAspects + aspects()
        var aspectId = self.id
        self.aspects.forEach { aspect in
            aspectId -= 1
            aspect.id = aspectId
        }
    }
}
