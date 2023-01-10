//
//  PersistentGraph.Member.TimedValue.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.12.22.
//

import Foundation

extension PersistentGraph {
    struct TimedValue: Serializable {
        @Serialized private(set) var time: Date
        @Serialized private(set) var storage: PersistentGraph.ValueStorage = .nil

        var value: (any PersistentGraph.PersistentValue)? {
            get {
                return storage.value
            }
            set {
                storage = PersistentGraph.ValueStorage(newValue)
            }
        }

        subscript<T: PersistentData.PersistentValue>(_ type: T.Type) -> T? {
            let value = value
            return value as? T
        }

        init() {}

        init(time: Date, value: (any PersistentGraph.PersistentValue)?) {
            self.time = time
            self.value = value
        }
    }
}
