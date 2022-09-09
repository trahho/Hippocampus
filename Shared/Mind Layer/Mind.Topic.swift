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
        @Serialized var associations: [Link] = []

        func rethink(of brain: Brain) {
            var ideas: [Brain.Neuron.ID: Idea] = [:]
            var links: [Brain.Neuron.ID: Link] = [:]
            for neuron in brain.neurons.values {
                guard ideas[neuron.id] == nil, let opinion = primary.map({ thought in thought.opinion(of: neuron) }).first(where: { opinion in opinion.matches }) else { continue }

                var ideaPerspective: Perspective?

                if let id = opinion.perspective, let perspective = brain.perspectives[id] {
                    ideaPerspective = perspective
                }
                let idea = Idea(neuron: neuron, perspective: ideaPerspective)
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
