//
//  Brain.Synapse.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

extension Brain {
    class Synapse: Information {
        @PublishedSerialized private(set) var emitter: Neuron
        @PublishedSerialized private(set) var receptor: Neuron

        required init() {}

//        override subscript(aspect: Aspect) -> Codable? {
//            get {
//                if receptor.takesPerspective(aspect.perspective) {
//                    return receptor[aspect]
//                } else if takesPerspective(aspect.perspective) {
//                    return super[aspect]
//                } else {
//                    return nil
//                }
//            }
//            set {
//                if receptor.takesPerspective(aspect.perspective) {
//                    receptor[aspect] = newValue
//                } else if takesPerspective(aspect.perspective) {
//                    super[aspect] = newValue
//                }
//            }
//        }

        func connect() {
            emitter.axons.insert(self)
            receptor.dendrites.insert(self)
        }
        
        func disconnect() {
            emitter.axons.remove(self)
            receptor.dendrites.remove(self)
        }

        init(pre: Neuron, post: Neuron) {
            super.init()
            self.emitter = pre
            self.receptor = post
            connect()
        }
    }
}
