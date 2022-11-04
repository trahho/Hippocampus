//
//  Mind.Thought.GlobalThoughts.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation

extension Mind.Thought {
    enum GlobalThoughts: Mind.Thought.ID, CaseIterable {
        case notes
        case drawings
    }

    @Builder static func buildGlobalThoughts() -> [Mind.Thought.ID: Mind.Thought] {
        Mind.Thought(.notes, "Notizen") {
            .takesPerspective(Perspective.note) || .takesPerspective(Perspective.topic)
        }
        Mind.Thought(.drawings, "Zeichnungen") {
            .takesPerspective(Perspective.drawing) || .takesPerspective(Perspective.topic)
        }
    }

    static let globalThoughts: [Mind.Thought.ID: Mind.Thought] = buildGlobalThoughts()

    static subscript(dynamicMember designation: String) -> Mind.Thought {
        let thoughtId = -GlobalThoughts.from(string: designation.lowercased())!.rawValue
        return globalThoughts.values.first { $0.id == thoughtId }!
    }
    
    convenience init(_ id: GlobalThoughts, _ designation: String, @Mind.Opinion.Builder opinions: () -> [Mind.Opinion]) {
        self.init()
        self.id = -id.rawValue
        self.designation = designation
        self.opinions = opinions()
    }

}
