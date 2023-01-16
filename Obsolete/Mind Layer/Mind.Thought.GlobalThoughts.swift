//
//  Mind.Thought.GlobalThoughts.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation

extension Mind.Thought {
    enum GlobalThoughts: String, CaseIterable {
        case notes = "2F0E3006-A54F-4E09-8946-5919272FE4F5"
        case drawings = "DC23F51B-5CF5-4A25-829B-C27AFAF89547"

        var id: UUID { UUID(uuidString: rawValue)! }
    }

    @Builder
    static func buildGlobalThoughts() -> [Mind.Thought.ID: Mind.Thought] {
        Mind.Thought(.notes, "Notizen") {
            .takesPerspective(Perspective.note) || .takesPerspective(Perspective.topic)
        }
        Mind.Thought(.drawings, "Zeichnungen") {
            .takesPerspective(Perspective.drawing) || .takesPerspective(Perspective.topic)
        }
    }

    static let globalThoughts: [Mind.Thought.ID: Mind.Thought] = buildGlobalThoughts()

    static subscript(dynamicMember designation: String) -> Mind.Thought {
        let thoughtId = GlobalThoughts.from(string: designation.lowercased())!.id
        return globalThoughts.values.first { $0.id == thoughtId }!
    }
}
