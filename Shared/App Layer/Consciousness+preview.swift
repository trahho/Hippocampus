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
        neuron1[Perspective.thema.name] = "A"
        let neuron2 = Brain.Neuron()
        neuron2[Perspective.thema.name] = "B"
        let neuron3 = Brain.Neuron()
        neuron3[Perspective.thema.name] = "C"

        brain.add(synapse: Brain.Synapse(pre: neuron1, post: neuron2))
        brain.add(synapse: Brain.Synapse(pre: neuron2, post: neuron3))
        brain.add(synapse: Brain.Synapse(pre: neuron3, post: neuron1))

//        let topic = Mind.Topic()
//        let thought = Mind.Thought()
//        thought.opinion = Mind.Opinion.takesPerspective(Perspective.thema)
//        topic.thoughts.append(thought)
//
//        memory.mind.add(topic: topic)

        let result = Consciousness()
        result.showMemory(memory)
        return result
    }()
}
