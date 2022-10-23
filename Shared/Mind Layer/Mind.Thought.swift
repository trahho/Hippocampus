//
//  Mind.Topic.swift
//  Hippocampus
//
//  Created by Guido Kühn on 09.08.22.
//

import Foundation

extension Mind {
    final class Thought: PersistentObject, ObservableObject {
        @PublishedSerialized var designation: String = ""
        @Published var opinions: [Opinion] = []

        var ideas: [Idea] = []
        var links: [Link] = []

//        var links: [Link] {
//            Array(internalLinks.values)
//        }

        private var internalIdeas: [Idea.ID: Idea] = [:]
        private var internalLinks: [Link.ID: Link] = [:]
        private var brain: Brain?

        convenience init(_ opinions: [Opinion]) {
            self.init()
            self.opinions = opinions
        }

        func rethink(of brain: Brain) {
            guard self.brain == nil else { return }
            self.brain = brain
            for neuron in brain.neurons.values {
                analyze(neuron: neuron)
            }
            objectWillChange.send()
            ideas = Array(internalIdeas.values)
            links = Array(internalLinks.values)
            self.brain = nil
            internalIdeas = [:]
            internalLinks = [:]
        }

        func agree(_ information: Brain.Information) -> Set<Perspective>? {
            let agreement = opinions
                .reduce((matches: false, perspectives: Set<Perspective>())) { agreement, opinion in
                    let acceptance = opinion.take(for: information)
                    let acceptedPerspectives = acceptance.perspectives
                    return (agreement.matches || acceptance.matches, agreement.perspectives.union(acceptedPerspectives))
                }
            return agreement.matches ? agreement.perspectives : nil
        }

        func analyze(neuron: Brain.Neuron) {
            guard internalIdeas[neuron.id] == nil else { return }
            let perspectives = agree(neuron)
            if let perspectives {
                let idea = Idea(neuron: neuron, perspectives: perspectives)
                internalIdeas[idea.id] = idea
                for synapse in neuron.axons {
                    analyze(synapse: synapse)
                }
            }
        }

        func analyze(synapse: Brain.Synapse) {
            guard internalLinks[synapse.id] == nil else { return }
            analyze(neuron: synapse.receptor)
            guard let from = internalIdeas[synapse.emitter.id], let to = internalIdeas[synapse.receptor.id] else { return }
            let link = Link(synapse: synapse, perspectives: agree(synapse) ?? [], from: from, to: to)
            internalLinks[link.id] = link
            from.to.insert(link)
            to.from.insert(link)
        }
    }
}

extension Mind.Thought {
    static let thoughts: [Mind.Thought.ID: Mind.Thought] = {
        let topics: [Mind.Thought] = [
        ]
        var result: [Mind.Thought.ID: Mind.Thought] = [:]
        var id: Mind.Thought.ID = 0
        for topic in topics {
            id = id - 1
            topic.id = id
            result[id] = topic
        }
        return result
    }()
}
