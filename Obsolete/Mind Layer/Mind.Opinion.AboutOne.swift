//
//  Mind.Opinion.AboutOne.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.09.22.
//

import Foundation

extension Mind.Opinion {
    class AboutOne: Mind.Opinion {
        @Serialized var opinion: Mind.Opinion

        required init() {}

        init(_ opinion: Mind.Opinion) {
            super.init()
            self.opinion = opinion
        }

        class Wrong: AboutOne {
            override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
                let opinion = opinion.take(for: information)
                return (!opinion.matches, !opinion.matches ? opinion.perspectives : [])
            }
        }

        class Acquaintance: AboutOne {
            enum Familiarity {
                case knows, known, unknowing, unknown
            }

            @Serialized var familiarity: Familiarity

            init(_ familiarity: Familiarity, _ opinion: Mind.Opinion) {
                super.init(opinion)
                self.familiarity = familiarity
            }

            required init() {
                super.init()
            }

            override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
                if let synapse = information as? Brain.Synapse {
                    switch familiarity {
                    case .knows:
                        let result = opinion.take(for: synapse.receptor)
                        return (result.matches, result.matches ? result.perspectives : [])
                    case .known:
                        let result = opinion.take(for: synapse.emitter)
                        return (result.matches, result.matches ? result.perspectives : [])
                    case .unknowing:
                        return (false, [])
                    case .unknown:
                        return (false, [])
                    }
                } else if let neuron = information as? Brain.Neuron {
                    switch familiarity {
                    case .knows:
                        guard let result = neuron.axons.flatMap({ [opinion.take(for: $0.receptor), opinion.take(for: $0)] }).first(where: { $0.matches }) else { return (false, []) }
                        return result
                    case .known:
                        guard let result = neuron.dendrites.flatMap({ [opinion.take(for: $0.emitter), opinion.take(for: $0)] }).first(where: { $0.matches }) else { return (false, []) }
                        return result
                    case .unknowing:
                        return (neuron.axons.isEmpty, [])
                    case .unknown:
                        return (neuron.dendrites.isEmpty, [])
                    }
                } else {
                    return (false, [])
                }
            }
        }
    }
}
