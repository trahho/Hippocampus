//
//  File.swift
//
//
//  Created by Guido Kühn on 04.05.23.
//

import Foundation
public extension ObjectStore {
    class ObjectsStorageAbstract<T>: ObjectsStorage where T: Object {
        // MARK: - Key

        var key: String?
        var alternateKey: String?

        // MARK: - Initialization

        public init(key: String? = nil, alternateKey: String? = nil) {
            self.key = key
            self.alternateKey = alternateKey
        }

        func getObject(id: T.ID) -> T? { fatalError() }

        func getObjects() -> Set<T> { fatalError() }

        func addObject(item: T) { fatalError() }
    }

    class ObjectsStorageBase<T>: ObjectsStorageAbstract<T> where T: Object {
        // MARK: - Types

        typealias StorageDictionary = [T.ID: T]

        // MARK: - Restoration

        override public func merge(other: MergeableContent) throws {
            guard Self.self is MergeableContent, let other = other as? Self else { return }
            try mergeItems(other)
            importItems(other)
        }

        fileprivate func mergeItems(_ other: ObjectStore.ObjectsStorageBase<T>) throws {
            try Set(storage.keys).intersection(Set(other.storage.keys))
                .forEach { key in
                    let ownMergeable = storage[key] as! MergeableContent
                    let otherMergeable = other.storage[key] as! MergeableContent
                    try ownMergeable.merge(other: otherMergeable)
                }
        }

        fileprivate func importItems(_ other: ObjectStore.ObjectsStorageBase<T>) {
            Set(other.storage.keys).subtracting(Set(storage.keys))
                .forEach { key in
                    guard let item = other.storage[key] else { return }
                    storage[key] = item
                }
        }

        override public func setStore(store: ObjectStore) {
            self.store = store
            storage.values.forEach { $0.store = store }
        }

        // MARK: - Storage

        var storage: StorageDictionary = [:]

        override func getObject(id: T.ID) -> T? {
            storage[id]
        }

        override func getObjects() -> Set<T> {
            Set(storage.values)
        }

        override func addObject(item: T) {
            guard storage[item.id] == nil else { return }
            storage[item.id] = item
        }
    }
}
