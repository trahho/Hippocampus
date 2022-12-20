//
//  Perspective.GlobalPerspectives.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation

extension Perspective {
    enum GlobalPerspectives: String, CaseIterable {
        case global = "D7812874-085B-4161-9ABB-C82D4A145634"
        case drawing = "6247260E-624C-48A1-985C-CDEDDFA5D3AD"
        case topic = "3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0"
        case note = "8AB172CF-2330-4861-B551-8728BA6062BF"

        var id: UUID { UUID(uuidString: rawValue)! }
    }

    static let globalPerspectives = buildPerspectives {
        Perspective(.global, "Global") {
            Aspect("8A81358C-2A7C-497D-A93D-306F776C217C", "Name", .text)
        }
    }.addGroup("Basiselemente") {
        Perspective(.drawing, "Zeichnung") {
            Aspect("B6D7755C-210C-484D-B79B-ACD931D581C9", "Zeichnung", .drawing)
        }
    }.addGroup("Notizen") {
        Perspective(.topic, "Thema", [Perspective.global]) {}
        Perspective(.note, "Notiz", [Perspective.global, Perspective.drawing]) {
            Aspect("B945443A-32D6-4FE7-A63F-65436CAAA3CA", "Titel", .text)
            Aspect("8C6872C7-9E9F-470F-9E23-3A7277B1A9ED", "Text", .text)
        }
    }

    static subscript(dynamicMember designation: String) -> Perspective {
        let perspectiveId = GlobalPerspectives.from(string: designation.lowercased())!.id
        return globalPerspectives.values.first { $0.id == perspectiveId }!
    }

    convenience init(_ id: GlobalPerspectives, _ designation: String, _ perspectivesBuilder: @autoclosure @escaping PerspectiveReferences = [Perspective](), @Aspect.Builder aspects: () -> [Aspect]) {
        self.init()
        self.id = id.id
        self.perspectivesBuilder = perspectivesBuilder
        self.designation = designation
//        let globalAspects = [Aspect("Created", .date), Aspect("Modified", .date)]
        aspects().forEach { aspect in
            self.addAspect(aspect)
        }
    }
}
