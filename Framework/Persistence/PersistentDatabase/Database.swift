//
//  Database.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.04.23.
//

import Foundation

open class Database<ValueStorage: TimedValueStorage>: PersistentData {
    public typealias PersistentValue = TimedValueStorage.PersistentValue
    public typealias Key = String

    private(set) var timestamp: Date?
    @Serialized var timestamps: Set<Date>

    func willChange() {
        objectWillChange.send()
    }

    func didChange(timestamp: Date) {
        timestamps.insert(timestamp)
        objectDidChange.send()
    }

    public func add<T>(item: T, timestamp: Date? = nil) where T : Database.Object {
        item.added = item.added ?? timestamp
        super.add(item: item)
//        item.adopt(timestamp: timestamp)
    }
    
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
