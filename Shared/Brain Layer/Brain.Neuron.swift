//
//  Brain.Neuron.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

extension Brain {
    class Neuron: Information {
        @Published var dendrites: Set<Synapse>=[]
        @Published var axons: Set<Synapse>=[]

        required init() {}
    }
}
