//
//  Brain.thought.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.08.22.
//

import Foundation

infix operator <~: DefaultPrecedence

extension Mind {
    indirect enum Thought: Codable {
        case about(synapse: Thought, neuron: Thought)
        case always(Bool)
        case opposite(Thought)
        case any([Thought])
        case all([Thought])
        case knownBy(Thought)
        case knows(Thought)
        case hasAxon(Thought)
        case hasDendrite(Thought)
        case takeOpinion(when: Thought, of: Perspective.ID)
        case hasPerspective(Perspective.ID)
        case aspectIsEqual(Aspect.ID, String)
        case aspectIsBelow(Aspect.ID, String)
        case aspectIsAbove(Aspect.ID, String)

        func opinion(of neuron: Brain.Neuron) -> (matches: Bool, perspective: Perspective.ID?) {
            switch self {
            case let .about(_, neuronThought):
                return neuronThought.opinion(of: neuron)
            case let .always(truth):
                return (truth, nil)
            case let .opposite(thought):
                let opinion = thought.opinion(of: neuron)
                return (!opinion.matches, opinion.perspective)
            case let .any(thoughts):
                return thoughts.map { $0.opinion(of: neuron) }.first { $0.matches } ?? (false, nil)
            case let .all(thoughts):
                return thoughts.reduce((matches: false, perspective: nil)) { sum, thought in
                    let opinion = thought.opinion(of: neuron)
                    return (sum.matches && opinion.matches, sum.perspective ?? opinion.perspective)
                }
            case let .takeOpinion(thought, perspective):
                return (thought.opinion(of: neuron).matches, perspective)
            case let .hasPerspective(id):
                return (neuron.perspectives.contains(id), nil)
            case let .knownBy(thought):
                return neuron.dendrites.map { thought.opinion(of: $0.pre) }.first { $0.matches } ?? (false, nil)
            case let .knows(thought):
                return neuron.dendrites.map { thought.opinion(of: $0.post) }.first { $0.matches } ?? (false, nil)
            case let .hasAxon(thought):
                return neuron.axons.map { thought.opinion(of: $0) }.first { $0.matches } ?? (false, nil)
            case let .hasDendrite(thought):
                return neuron.dendrites.map { thought.opinion(of: $0) }.first { $0.matches } ?? (false, nil)
            case let .aspectIsEqual(id, value):
                return (isEqual(neuron.aspects[id], value), nil)
            case let .aspectIsBelow(id, value):
                return (isBelow(neuron.aspects[id], value), nil)
            case let .aspectIsAbove(id, value):
                return (isAbove(neuron.aspects[id], value), nil)
            }
        }

        func opinion(of synapse: Brain.Synapse) -> (matches: Bool, perspective: Perspective.ID?) {
            switch self {
            case let .about(synapseThought, _):
                return synapseThought.opinion(of: synapse)
            case let .always(truth):
                return (truth, nil)
            case let .opposite(thought):
                let opinion = thought.opinion(of: synapse)
                return (!opinion.matches, opinion.perspective)
            case let .any(thoughts):
                return thoughts.map { $0.opinion(of: synapse) }.first { $0.matches } ?? (false, nil)
            case let .all(thoughts):
                return thoughts.reduce((matches: false, perspective: nil)) { sum, thought in
                    let opinion = thought.opinion(of: synapse)
                    return (sum.matches && opinion.matches, sum.perspective ?? opinion.perspective)
                }
            case let .takeOpinion(thought, perspective):
                return (thought.opinion(of: synapse).matches, perspective)
            case let .hasPerspective(id):
                return (synapse.perspectives.contains(id), nil)
            case let .knownBy(thought):
                return thought.opinion(of: synapse.pre)
            case let .knows(thought):
                return thought.opinion(of: synapse.post)
            case .hasAxon:
                return (false, nil)
            case .hasDendrite:
                return (false, nil)
            case let .aspectIsEqual(id, value):
                return (isEqual(synapse.aspects[id], value), nil)
            case let .aspectIsBelow(id, value):
                return (isBelow(synapse.aspects[id], value), nil)
            case let .aspectIsAbove(id, value):
                return (isAbove(synapse.aspects[id], value), nil)
            }
        }

        static let dateFormatter: DateFormatter = {
            let result = DateFormatter()
            result.dateStyle = .full
            result.timeStyle = .full
            return result
        }()

        func isEqual(_ aspectValue: Codable?, _ value: String) -> Bool {
            guard let aspectValue = aspectValue else { return false }
            if let aspectValue = aspectValue as? String {
                return aspectValue == value
            } else if let aspectValue = aspectValue as? Int, let value = Int(value) {
                return aspectValue == value
            } else if let aspectValue = aspectValue as? Date, let value = Self.dateFormatter.date(from: value) {
                return aspectValue == value
            } else {
                return false
            }
        }

        func isBelow(_ aspectValue: Codable?, _ value: String) -> Bool {
            guard let aspectValue = aspectValue else { return true }
            if let aspectValue = aspectValue as? String {
                return aspectValue < value
            } else if let aspectValue = aspectValue as? Int, let value = Int(value) {
                return aspectValue < value
            } else if let aspectValue = aspectValue as? Date, let value = Self.dateFormatter.date(from: value) {
                return aspectValue < value
            } else {
                return false
            }
        }

        func isAbove(_ aspectValue: Codable?, _ value: String) -> Bool {
            guard let aspectValue = aspectValue else { return false }
            if let aspectValue = aspectValue as? String {
                return aspectValue > value
            } else if let aspectValue = aspectValue as? Int, let value = Int(value) {
                return aspectValue > value
            } else if let aspectValue = aspectValue as? Date, let value = Self.dateFormatter.date(from: value) {
                return aspectValue > value
            } else {
                return false
            }
        }

        static prefix func ! (rhs: Thought) -> Thought {
            .opposite(rhs)
        }

        static func && (lhs: Thought, rhs: Thought) -> Thought {
            if case let .all(thoughts) = lhs {
                return .all(thoughts + [rhs])
            } else if case let .all(thoughts) = rhs {
                return .all([lhs] + thoughts)
            } else {
                return .all([lhs, rhs])
            }
        }

        static func || (lhs: Thought, rhs: Thought) -> Thought {
            if case let .any(thoughts) = lhs {
                return .any(thoughts + [rhs])
            } else if case let .any(thoughts) = rhs {
                return .any([lhs] + thoughts)
            } else {
                return .any([lhs, rhs])
            }
        }

        static func ~> (lhs: Thought, rhs: Thought) -> Thought {
            lhs && .knows(rhs)
        }

        static func <~ (lhs: Thought, rhs: Thought) -> Thought {
            .knownBy(lhs) && rhs
        }
    }
}
