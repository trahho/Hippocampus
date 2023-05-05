//
//  File.swift
//
//
//  Created by Guido Kühn on 04.05.23.
//

import Foundation
public extension ObjectStore {
    class ObjectsStorageBase<T>: ObjectsStorage where T: Object {
        // MARK: - Types

        typealias StorageDictionary = [T.ID: T]

        // MARK: - Key

        var key: String?
        var alternateKey: String?

        // MARK: - Initialization

        public init(key: String? = nil, alternateKey: String? = nil) {
            self.key = key
            self.alternateKey = alternateKey
        }

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

        var store: ObjectStore!
        var storage: StorageDictionary = [:]

        func getObject(id: T.ID) -> T? {
            storage[id]
        }

        func getObjects() -> Set<T> {
            Set(storage.values)
        }

        func addObject(item: T) {
            guard storage[item.id] == nil else { return }
            storage[item.id] = item
        }
    }
}

extension ObjectStore.ObjectsStorageBase: EncodableProperty where T: Encodable {
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        guard !storage.isEmpty else { return }
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        let value = Array(storage.values)
        try container.encodeIfPresent(value, forKey: codingKey)
    }
}

extension ObjectStore.ObjectsStorageBase: DecodableProperty where T: Decodable {
    public func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        if let value = try? container.decodeIfPresent([T].self, forKey: codingKey) {
            storage = Dictionary(uniqueKeysWithValues: value.map { ($0.id, $0) })
        } else {
            guard let altKey = alternateKey else { return }
            let altCodingKey = SerializedCodingKeys(key: altKey)
            if let value = try? container.decodeIfPresent(Set<T>.self, forKey: altCodingKey) {
                storage = Dictionary(uniqueKeysWithValues: value.map { ($0.id, $0) })
            }
        }
    }
}
