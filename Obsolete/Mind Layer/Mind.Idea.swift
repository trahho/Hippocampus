//
//  Mind.Idea.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.08.22.
//

import Foundation
extension Mind {
    class Idea: Thing {
        var from: Set<Link> = []
        var to: Set<Link> = []

        init(brain: Brain, neuron: Brain.Neuron, perspectives: Set<Perspective>) {
            super.init(brain: brain, information: neuron, perspectives: perspectives)
        }
    }
}
