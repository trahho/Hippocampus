//
//  Brain.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

final class Brain: Serializable, ObservableObject {
    @Serialized private var informationId: Information.ID = 0
    @Serialized private var perspectiveId: Information.ID = 0
    @Serialized private var aspectId: Information.ID = 0
    @PublishedSerialized private(set) var neurons: [Information.ID: Neuron] = [:]
    @PublishedSerialized private(set) var synapses: [Information.ID: Synapse] = [:]
    @PublishedSerialized private var customPerspectives: [Perspective] = []

    var perspectives: [Perspective] {
        Perspective.perspectives + customPerspectives
    }

    func recover() {
        synapses.values.forEach { synapse in
            synapse.connect()
        }
    }

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
}
