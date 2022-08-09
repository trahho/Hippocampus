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
        case opposite(Criterion)
        case any([Criterion])
        case all([Criterion])
        case hasPerspective(Brain.Perspective.ID)
        case knownBy(Criterion)
        case knows(Criterion)
        case hasAxon(Criterion)
        case hasDendrite(Criterion)

        func isValid(for neuron: Brain.Neuron) -> Bool {
            switch self {
            case let .is(truth):
                return truth
            case let .opposite(criterion):
                return !criterion.isValid(for: neuron)
            case let .any(criteria):
                return criteria.contains { $0.isValid(for: neuron) }
            case let .all(criteria):
                return criteria.allSatisfy { $0.isValid(for: neuron) }
            case let .hasPerspective(id):
                return neuron.perspectives.contains(id)
            case let .knownBy(criterion):
                return neuron.dendrites.contains { criterion.isValid(for: $0.pre) }
            case let .knows(criterion):
                return neuron.axons.contains { criterion.isValid(for: $0.post) }
            case let .hasAxon(criterion):
                return neuron.axons.contains { criterion.isValid(for: $0) }
            case let .hasDendrite(criterion):
                return neuron.dendrites.contains { criterion.isValid(for: $0) }
            }
        }

        func isValid(for synapse: Brain.Synapse) -> Bool {
            switch self {
            case let .is(truth):
                return truth
            case let .opposite(criterion):
                return !criterion.isValid(for: synapse)
            case let .any(criteria):
                return criteria.contains { $0.isValid(for: synapse) }
            case let .all(criteria):
                return criteria.allSatisfy { $0.isValid(for: synapse) }
            case let .hasPerspective(id):
                return synapse.perspectives.contains(id)
            case let .knownBy(criterion):
                return criterion.isValid(for: synapse.pre)
            case let .knows(criterion):
                return criterion.isValid(for: synapse.post)
            case let .hasAxon(criterion):
                return synapse.pre.axons.contains { criterion.isValid(for: $0) }
            case let .hasDendrite(criterion):
                return synapse.post.dendrites.contains { criterion.isValid(for: $0) }
            }
        }

        static prefix func ! (rhs: Criterion) -> Criterion {
            .opposite(rhs)
        }

        static func && (lhs: Criterion, rhs: Criterion) -> Criterion {
            if case let .all(criteria) = lhs {
                return .all(criteria + [rhs])
            } else if case let .all(criteria) = rhs {
                return .all([lhs] + criteria)
            } else {
                return .all([lhs, rhs])
            }
        }

        static func || (lhs: Criterion, rhs: Criterion) -> Criterion {
            if case let .any(criteria) = lhs {
                return .any(criteria + [rhs])
            } else if case let .any(criteria) = rhs {
                return .any([lhs] + criteria)
            } else {
                return .any([lhs, rhs])
            }
        }
    }
}
