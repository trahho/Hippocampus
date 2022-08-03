//
//  Consciousness.preview.swift
//  Hippocampus
//
//  Created by Guido Kühn on 01.08.22.
//

import Foundation

extension Consciousness {
    static var preview1: Consciousness = {
        let area = Brain.Area.makeVirtualArea()
        let brain = area.brain
        let neuron1 = brain.createNeuron()
        let neuron2 = brain.createNeuron()
        _ = brain.createSynapse(pre: neuron1, post: neuron2)

        let result = Consciousness()
        result.showArea(area: area)
        return result
    }()
}
