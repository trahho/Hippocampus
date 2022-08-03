//
//  Brain.Synapse.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

extension Brain {
    class Synapse: Information {
        @Serialized var pre: Neuron
        @Serialized var post: Neuron

        required init() {}

        init(pre: Neuron, post: Neuron) {
            super.init()
            self.pre = pre
            self.post = post
        }
    }
}
