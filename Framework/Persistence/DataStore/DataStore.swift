//
//  Database.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.04.23.
//

import Foundation

/// Jetzt kommt eine database, die aus mehreren databases besteht. Das wird ein Document. Und einen eigenen Container DatabaseContainer
/// Das restore verliert wieder den content, denn der Container weiß es selber. Er gibt der Database sich selbst, und erhält vom Document

open class DataStore<ValueStorage: TimedValueStorage>: ObjectStore {
    public typealias PersistentValue = TimedValueStorage.PersistentValue
    public typealias Key = String

   

    @Serialized var timestamps: Set<Date>

    

    
    

//    func add(_ node: Node, timestamp: Date? = nil) {
//        guard nodeStorage[node.id] == nil else { return }
//        objectWillChange.send()
//
//        let timestamp = timestamp ?? Date()
//
//        if node.added == nil {
//            node.added = timestamp
//        }
//        node.graph = self
//        nodeStorage[node.id] = node
//        node.adopt(timestamp: timestamp)
//        publishDidChange()
//    }
}
