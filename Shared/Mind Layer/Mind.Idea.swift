//
//  Mind.Idea.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.08.22.
//

import Foundation
extension Mind {
    class Idea: IdentifiableObject {
        @Observed var receptor: Brain.Neuron
        @Observed var axon: Brain.Synapse
        var perspectives: [Perspective]

        override var id: ID {
            get {
                axon.id
            }
            set {}
        }

        subscript(_ aspect: Aspect) -> Codable? {
            get {
                aspect[axon]
            }
            set {
                aspect[axon] = newValue
            }
        }

        init(synapse: Brain.Synapse, perspectives: [Perspective]) {
            self.perspectives = perspectives
            super.init()
            self.axon = synapse
            self.receptor = synapse.receptor
        }
    }
}
