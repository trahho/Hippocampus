//
//  Consciousness.preview.swift
//  Hippocampus
//
//  Created by Guido Kühn on 01.08.22.
//

import Foundation

extension Consciousness {
    static var preview1: Consciousness = {
        let memory = Memory(url: URL.virtual())
        let brain = memory.brain
        let neuron1 = Brain.Neuron()
        let neuron2 = Brain.Neuron()
        let synapse = Brain.Synapse(pre: neuron1, post: neuron2)
        brain.add(neuron: neuron1)
        brain.add(neuron: neuron2)
        brain.add(synapse: synapse)

        let result = Consciousness()
        result.showMemory(memory)
        return result
    }()
}
