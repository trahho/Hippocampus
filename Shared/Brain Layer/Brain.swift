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
    @PublishedSerialized private var customPerspectives: [Perspective.ID: Perspective] = [:]

    var perspectives: [Perspective.ID: Perspective] {
        Perspective.perspectives.merging(customPerspectives, uniquingKeysWith: { $1 })
    }

    func recover() {
        synapses.values.forEach { synapse in
            synapse.connect()
        }
        customPerspectives.values.forEach { perspective in
            perspective.aspects.forEach { aspect in
                aspect.perspective = perspective
            }
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
