//
//  Mind.Link.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.08.22.
//

import Foundation
extension Mind {
    class Link: IdentifiableObject {
        @Observed var synapse: Brain.Synapse
        var perspective: Perspective.ID

        init(synapse: Brain.Synapse, perspective: Perspective.ID) {
            self.perspective = perspective
            super.init()
            self.synapse = synapse
        }
    }
}
