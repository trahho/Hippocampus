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

    override func addObject<T>(item: T) throws where T: ObjectStore.Object {
        guard let storage = storage(type: T.self) else { throw DatabaseDocument.Failure.typeNotFound }
        guard storage.getObject(id: item.id) == nil else { return }

        objectWillChange.send()
        storage.addObject(item: item)
        item.store = self
        if let data = item as? Object {
            data.added = document.writingTimestamp
            data.adopt(document: document)
        }
        objectDidChange.send()
    }
}
