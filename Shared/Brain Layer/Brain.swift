//
//  Brain.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

class Brain: Serializable, ObservableObject {
    @Serialized private var informationId: Int = 1
    @PublishedSerialized private(set) var neurons: [Int: Neuron] = [:]
    @PublishedSerialized private(set) var synapses: [Int: Synapse] = [:]

    let staticPerspective: [Perspective] = buildPerspectives {
        Perspective("Hallo") {
            Aspect("Welt", .text)
            Aspect("Sonnenuntergang", .drawing)
        }
    }

    required init() {}

    func add(neuron: Neuron) {
        if neuron.id == 0 {
            neuron.setId(informationId ++)
        }
    }

    func createSynapse(pre: Neuron, post: Neuron) -> Synapse {
        let synapse = Synapse(pre: pre, post: post)
        synapses.append(synapse)
        return synapse
    }
}
