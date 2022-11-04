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

        static func buildBlock(_ thoughts: Mind.Thought...) -> [Mind.Thought.ID: Mind.Thought]  {
            thoughts.asDictionary(key: \.id)
        }
    }
}
