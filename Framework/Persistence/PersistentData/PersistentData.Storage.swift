//
//  PersistentData.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

protocol PersistenDataStorageWrapper {}

public extension PersistentData {
    class StorageWrapper: MergeableContent {
        public func setContainer(container: PersistentData) {}
        public func merge(other: MergeableContent) throws {}
    }

    @propertyWrapper
    final class Objects<T>: StorageWrapper  where T: Object {
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

        internal func get(id: PersistentObject.ID) -> PersistentData.Object? {
            storage[id]
        }

        internal func add(item: PersistentData.Object) {
            guard let item = item as? T else { return }
            storage[item.id] = item
        }

        public override func merge(other: MergeableContent) throws {
            guard let other = other as? Self else { return }
            try mergeItems(other)
            importItems(other)
        }

        fileprivate func importItems(_ other: PersistentData.Objects<T>) {
            Set(other.storage.keys).subtracting(Set(storage.keys))
                .forEach { key in
                    guard let item = other.storage[key] else { return }
                    storage[key] = item
                }
        }

        fileprivate func mergeItems(_ other: PersistentData.Objects<T>) throws {}

        fileprivate func mergeItems(_ other: PersistentData.Objects<T>) throws where T: MergeableContent {
            try Set(storage.keys).intersection(Set(other.storage.keys))
                .forEach { key in
                    try storage[key]!.merge(other: other.storage[key]!)
                }
        }

        public override func setContainer(container: PersistentData) {
            storage.values.forEach { $0.data = container }
        }
    }
}

extension PersistentData.Objects: EncodableProperty where T: Encodable {
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        guard !storage.isEmpty else { return }
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        let value = Array(storage.values)
        try container.encodeIfPresent(value, forKey: codingKey)
    }
}

extension PersistentData.Objects: DecodableProperty where T: Decodable {
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
