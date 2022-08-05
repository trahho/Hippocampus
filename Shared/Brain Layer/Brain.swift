//
//  Brain.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

class Brain: Serializable, ObservableObject {
    @Serialized private var informationId: Information.ID = 0
    @PublishedSerialized private(set) var neurons: [Information.ID: Neuron] = [:]
    @PublishedSerialized private(set) var synapses: [Information.ID: Synapse] = [:]

    let staticPerspective: [Perspective] = buildPerspectives {
        Perspective("Hallo") {
            Aspect("Welt", .text)
            Aspect("Sonnenuntergang", .drawing)
        }
    }

    required init() {}

    func add(neuron: Neuron) {
        if neuron.id == 0 {
            informationId += 1
            neuron.id = informationId
        }
        neurons[neuron.id] = neuron
    }
    
    func add(synapse: Synapse) {
        if synapse.id == 0 {
            informationId += 1
            synapse.id = informationId
        }
        synapses[synapse.id] = synapse
    }

//    func createSynapse(pre: Neuron, post: Neuron) -> Synapse {
//        let synapse = Synapse(pre: pre, post: post)
//        synapses.append(synapse)
//        return synapse
//    }
}
