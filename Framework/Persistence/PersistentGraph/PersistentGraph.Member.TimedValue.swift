//
//  PersistentGraph.Member.TimedValue.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.12.22.
//

import Foundation

extension PersistentGraph.Member {
    struct TimedValue: Serializable {
        @Serialized private(set) var time: Date
        @Serialized private(set) var value: (any PersistentGraph.PersistentValue)?

        init() {}

        init(time: Date, value: (any PersistentGraph.PersistentValue)?) {
            self.time = time
            self.value = value
        }
    }
}
