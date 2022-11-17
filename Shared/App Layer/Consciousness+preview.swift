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
        brain.dream {
            let neuron1 = Brain.Neuron()
            brain.add(neuron: neuron1)
            neuron1[Perspective.global.name] = "A"
            neuron1[Perspective.note.text] = "Erster Text"
            
            let neuron2 = Brain.Neuron()
            brain.add(neuron: neuron2)
            neuron2[Perspective.global.name] = "B"
            neuron2[Perspective.note.text] = "Zweiter Text"
            
            let neuron3 = Brain.Neuron()
            brain.add(neuron: neuron3)
            neuron3[Perspective.global.name] = "C"
            neuron3[Perspective.note.text] = "Dritter Text"
            
            brain.add(synapse: Brain.Synapse(pre: neuron1, post: neuron2))
            brain.add(synapse: Brain.Synapse(pre: neuron2, post: neuron3))
            brain.add(synapse: Brain.Synapse(pre: neuron3, post: neuron1))
        }
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
