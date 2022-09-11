//
//  Mind.Topic.swift
//  Hippocampus
//
//  Created by Guido Kühn on 09.08.22.
//

import Foundation

extension Mind {
    final class Topic: PersistentObject {
        @Serialized var primary: [Thought] = []
        @Serialized var secondary: [Thought] = []
        @Serialized var stimuli: [Idea] = []
        @Serialized var consequences: [Idea] = []

        func rethink(of brain: Brain) {
            primary = brain.synapses.compactMapValues({ synapse in
                let axonOpinion = primary.map { thought in
                    thought.opinion(of: synapse)
                }.first { opinion in
                    opinion.matches
                }
                let receptorOpinion = primary.map { thought in
                    thought.opinion(of: synapse.)
                }.first { opinion in
                    opinion.matches
                }
            })
            
            
            var ideas: [Idea] = []
            
            for neuron in brain.neurons.values {
                guard ideas[neuron.id] == nil, let opinion = primary.map({ thought in thought.opinion(of: neuron) }).first(where: { opinion in opinion.matches }) else { continue }

                var ideaPerspective: Perspective?

                if let id = opinion.perspective, let perspective = brain.perspectives[id] {
                    ideaPerspective = perspective
                }
                
            }
        }
    }
}

extension Array where Array.Element == Perspective {
    subscript (_ id: Perspective.ID) -> Perspective? {
        get {
            self.first(where: {$0.id == id})
        }
    }
}
