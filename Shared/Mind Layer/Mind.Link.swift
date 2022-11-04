//
//  Mind.Link.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.09.22.
//

import Foundation

extension Mind {
    class Link: Thing {
        var from: Idea
        var to: Idea

        init(brain: Brain, synapse: Brain.Synapse, perspectives: Set<Perspective>, from: Idea, to: Idea) {
            self.from = from
            self.to = to
            super.init(brain: brain, information: synapse, perspectives: perspectives)
        }
    }
}
