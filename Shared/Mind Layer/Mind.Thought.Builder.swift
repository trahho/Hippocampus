//
//  Mind.Thought.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation
extension Mind.Thought {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Mind.Thought.ID: Mind.Thought] { [:] }

        static func buildBlock(_ thoughts: Mind.Thought...) -> [Mind.Thought.ID: Mind.Thought] {
            thoughts.asDictionary(key: \.id)
        }
    }

    convenience init(_ id: GlobalThoughts, _ designation: String, @Mind.Opinion.Builder opinions: () -> [Mind.Opinion]) {
        self.init()
        self.id = id.id
        self.designation = designation
        self.opinions = opinions()
    }
}
