//
//  Brain.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

class Brain: Serializable {
    @Serialized private (set) var neurons: [Neuron] = []
    @Serialized var synapses: [Synapse] = []
    required init() {}
    
    func createNeuron() -> Neuron{
        let neuron = Neuron()
        neurons.append(neuron)
        return neuron
    }
    
    func createSynapse(pre: Neuron, post: Neuron) -> Synapse {
        let synapse = Synapse(pre: pre, post: post)
        synapses.append(synapse)
        return synapse
    }
}



