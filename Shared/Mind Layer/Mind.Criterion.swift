//
//  Brain.Criterion.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.08.22.
//

import Foundation

extension Mind {
    indirect enum Criterion: Codable {
        case `is`(Bool)
        case any([Criterion])
        case all([Criterion])
        case hasPerspective(Brain.Perspective.ID)
        case knownBy(Criterion)
        case knows(Criterion)
        case hasAxon(Criterion)
        case hasDendrite(Criterion)

        func isValid(for neuron: Brain.Neuron) -> Bool {
            switch self {
            case .is(let truth):
                return truth
            case .any(let criteria):
                return criteria.contains { $0.isValid(for: neuron) }
            case .all(let criteria):
                return criteria.allSatisfy { $0.isValid(for: neuron) }
            case .hasPerspective(let id):
                return neuron.perspectives.contains(id)
            case .knownBy(let criterion):
                return neuron.dendrites.contains { criterion.isValid(for: $0.pre) }
            case .knows(let criterion):
                return neuron.axons.contains { criterion.isValid(for: $0.post) }
            case .hasAxon(let criterion):
                return neuron.axons.contains { criterion.isValid(for: $0) }
            case .hasDendrite(let criterion):
                return neuron.dendrites.contains { criterion.isValid(for: $0) }
            }
        }

        func isValid(for synapse: Brain.Synapse) -> Bool {
            switch self {
            case .is(let truth):
                return truth
            case .any(let criteria):
                return criteria.contains { $0.isValid(for: synapse) }
            case .all(let criteria):
                return criteria.allSatisfy { $0.isValid(for: synapse) }
            case .hasPerspective(let id):
                return synapse.perspectives.contains(id)
            case .knownBy(let criterion):
                return criterion.isValid(for: synapse.pre)
            case .knows(let criterion):
                return criterion.isValid(for: synapse.post)
            case .hasAxon(let criterion):
                return synapse.pre.axons.contains { criterion.isValid(for: $0) }
            case .hasDendrite(let criterion):
                return synapse.post.dendrites.contains { criterion.isValid(for: $0) }
            }
        }
    }
}
