//
//  PersistentData.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Foundation

open class PersistentData<Storage: TimedValueStorage>: PersistentGraph<String, String, Storage> {
    subscript<T>(_ id: Object.ID) -> T? {
        nodeStorage[id] as? T ?? edgeStorage[id] as? T
    }

    var changeTimestamp: Date?
}
