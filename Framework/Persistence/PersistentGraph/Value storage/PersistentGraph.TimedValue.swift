//
//  PersistentGraph.Member.TimedValue.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.12.22.
//

import Foundation

public protocol ValueStorage: Codable, Equatable {
    typealias PersistentValue = Codable & Equatable

    init(_ value: (any PersistentValue)?)
    var value: (any PersistentValue)? { get }
}

extension PersistentGraph {
    struct TimedValue<Storage: ValueStorage>: Serializable {
        @Serialized private(set) var time: Date
        @Serialized private(set) var storage: Storage?

        var value: (any Storage.PersistentValue)? {
            get {
                storage?.value
            }
            set {
                guard let newValue else {
                    storage = nil
                    return
                }
                storage = Storage(newValue)
            }
        }

        subscript<T: ValueStorage.PersistentValue>(type _: T.Type) -> T? {
            guard let value else { return nil }
            return value as? T
        }

        init() {}

        init(time: Date, value: (any PersistentGraph.PersistentValue)?) {
            self.time = time
            self.value = value
        }
    }
}
