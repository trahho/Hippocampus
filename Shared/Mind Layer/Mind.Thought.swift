//
//  Mind.Topic.swift
//  Hippocampus
//
//  Created by Guido Kühn on 09.08.22.
//

import Foundation

extension Mind {
    @dynamicMemberLookup
    final class Thought: PersistentObject, ObservableObject {
     

        @PublishedSerialized var designation: String = ""
        @PublishedSerialized var opinions: [Opinion] = []

//        var links: [Link] {
//            Array(internalLinks.values)
//        }

        func think(in brain: Brain) -> Conclusion {
            let conclusion = Conclusion()
            for neuron in brain.neurons.values {
                analyze(in: brain, neuron: neuron, for: conclusion)
            }
            return conclusion
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

        func analyze(in brain: Brain, neuron: Brain.Neuron, for conclusion: Conclusion) {
            guard conclusion.ideas[neuron.id] == nil else { return }
            let perspectives = agree(neuron)
            if let perspectives {
                let neuronPerspectives = perspectives.filter { neuron.takesPerspective($0) }
                let idea = Idea(brain: brain, neuron: neuron, perspectives: neuronPerspectives)
                conclusion.ideas[idea.id] = idea
                for synapse in neuron.axons {
                    analyze(in: brain, synapse: synapse, for: conclusion)
                }
            }
        }

        func analyze(in brain: Brain, synapse: Brain.Synapse, for conclusion: Conclusion) {
            guard conclusion.links[synapse.id] == nil else { return }
            analyze(in: brain, neuron: synapse.receptor, for: conclusion)
            guard let from = conclusion.ideas[synapse.emitter.id], let to = conclusion.ideas[synapse.receptor.id] else { return }
            let link = Link(brain: brain, synapse: synapse, perspectives: agree(synapse)?.filter { synapse.takesPerspective($0) } ?? [], from: from, to: to)
            conclusion.links[link.id] = link
            from.to.insert(link)
            to.from.insert(link)
        }
    }
}
