//
//  Mind.Thought.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.09.22.
//

import Foundation

extension Mind {
    final class Thought: PersistentObject, ObservableObject {
        @PublishedSerialized var designation: String = ""
        @PublishedSerialized var opinion: Opinion = .always(false)

        convenience init(designation: String, opinion: Opinion) {
            self.init()
            self.designation = designation
            self.opinion = opinion
        }
    }
}

