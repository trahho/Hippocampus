//
//  Brain.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

final class Brain: Serializable, ObservableObject {
    @Serialized private var informationId: Information.ID = 0
    @Serialized private var aspectId: Information.ID = 0
    @PublishedSerialized private(set) var neurons: [Information.ID: Neuron] = [:]
    @PublishedSerialized private(set) var synapses: [Information.ID: Synapse] = [:]

    

    func recover() {
        synapses.values.forEach { synapse in
            synapse.connect()
        }
      
    }

    func add(neuron: Neuron) {
        guard neurons[neuron.id] == nil else { return }
        if neuron.id == 0 {
            informationId += 1
            neuron.id = informationId
        }
        neurons[neuron.id] = neuron
    }

    func add(synapse: Synapse) {
        guard synapses[synapse.id] == nil else { return }
        if synapse.id == 0 {
            informationId += 1
            synapse.id = informationId
        }
        synapses[synapse.id] = synapse
        add(neuron: synapse.emitter)
        add(neuron: synapse.receptor)
    }
}
