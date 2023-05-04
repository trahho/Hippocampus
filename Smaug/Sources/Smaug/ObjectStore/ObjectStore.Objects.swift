//
//  PersistentData.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

public extension ObjectStore {
    @propertyWrapper
    final class Objects<T>: ObjectsStorage where T: Object {
        typealias StorageDictionary = [T.ID: T]

        var key: String?
        var alternateKey: String?

        private var storage: StorageDictionary = [:]

        public var wrappedValue: Set<T> {
            get {
                Set(storage.values)
            }
            set {}
        }

        public init(_ key: String? = nil, alternateKey: String? = nil) {
            self.key = key
            self.alternateKey = alternateKey
        }

        override public func merge(other: MergeableContent) throws {
            guard let other = other as? Self else { return }
            try mergeItems(other)
            importItems(other)
        }

        fileprivate func importItems(_ other: ObjectStore.Objects<T>) {
            Set(other.storage.keys).subtracting(Set(storage.keys))
                .forEach { key in
                    guard let item = other.storage[key] else { return }
                    storage[key] = item
                }
        }

        fileprivate func mergeItems(_ other: ObjectStore.Objects<T>) throws {}

        fileprivate func mergeItems(_ other: ObjectStore.Objects<T>) throws where T: MergeableContent {
            try Set(storage.keys).intersection(Set(other.storage.keys))
                .forEach { key in
                    try storage[key]!.merge(other: other.storage[key]!)
                }
        }

        override public func setStore(store: ObjectStore) {
            storage.values.forEach { $0.store = store }
        }

        // MARK: - Storage

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

extension ObjectStore.Objects: EncodableProperty where T: Encodable {
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        guard !storage.isEmpty else { return }
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        let value = Array(storage.values)
        try container.encodeIfPresent(value, forKey: codingKey)
    }
}

extension ObjectStore.Objects: DecodableProperty where T: Decodable {
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
