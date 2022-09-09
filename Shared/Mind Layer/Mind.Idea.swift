//
//  Mind.Idea.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.08.22.
//

import Foundation
extension Mind {
    class Idea: IdentifiableObject {
        @Observed var neuron: Brain.Neuron
        var perspective: Perspective?

        init(neuron: Brain.Neuron, perspective: Perspective?) {
            self.perspective = perspective
            super.init()
            self.neuron = neuron
        }
    }
}
