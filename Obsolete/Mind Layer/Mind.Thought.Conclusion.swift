//
//  Mind.Thought.Conclusion.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 12.11.22.
//

import Foundation

extension Mind.Thought {
    class Conclusion {
        var ideas: [Mind.Idea.ID: Mind.Idea] = [:]
        var links: [Mind.Link.ID: Mind.Link] = [:]
    }
}
