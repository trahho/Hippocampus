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
        neuron1[-1] = "Hallo"
        let neuron2 = Brain.Neuron()
        neuron2[-1] = "Welt"
        let synapse = Brain.Synapse(pre: neuron1, post: neuron2)
        brain.add(neuron: neuron1)
        brain.add(neuron: neuron2)
        brain.add(synapse: synapse)

        let criterion : Mind.Criterion = .any([
            .is(true),
                .knownBy(
                    .hasPerspective(Brain.Perspective["Hallo"].id))
        ])
        
        let result = Consciousness()
        result.showMemory(memory)
        return result
    }()
}
