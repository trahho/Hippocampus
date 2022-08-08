//
//  Brain.Synapse.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

extension Brain {
    class Synapse: Information {
        @PublishedSerialized private(set) var pre: Neuron
        @PublishedSerialized private(set) var post: Neuron

        required init() {}

        func connect() {
            pre.axons.insert(self)
            post.dendrites.insert(self)
        }

        init(pre: Neuron, post: Neuron) {
            super.init()
            self.pre = pre
            self.post = post
            connect()
        }
    }
}
