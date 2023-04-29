//
//  PersistentData.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

open class PersistentDynamicData: PersistentData {}

open class PersistentData: PersistentContent, Serializable, RestorableContent, MergeableContent, ContentContainer, ObservableObject, Reflectable {
    // MARK: - Types

    enum Fault: Error {
        case wrongMatch
        case mergeFailed
    }

    // MARK: - Data

    public var objectDidChange: ObjectDidChangePublisher = .init()

    // MARK: - Initialisation

    public required init() {}

    // MARK: - Persistence

    public func setup() -> Self {
        self
    }

    public func restore(container: ContentContainer?) {
        let mirror = mirror(for: RestorableContent.self)
        mirror.forEach {
            $0.value.restore(container: self)
        }
    }

    public func merge(other: MergeableContent) throws {
        guard let other = other as? Self else { throw MergeableContentMergeError.wrongMatch }

        for (own, other) in zip(mirror(for: MergeableContent.self), other.mirror(for: MergeableContent.self)) {
            try own.value.merge(other: other.value)
            if let restorable = own.value as? RestorableContent { restorable.restore(container: self) }
        }
    }



    // MARK: - Function

    public func add<T>(item: T) where T: Object {
        guard
            let storage = mirror(for: Storage<T>.self).first?.value,
            storage.get(id: item.id) == nil
        else { return }

        objectWillChange.send()
        storage.add(item: item)
        item.data = self
        objectDidChange.send()
    }

    public subscript<T>(_: T.Type, _ id: Object.ID) -> T? where T: Object {
        guard let storage = mirror(for: Storage<T>.self).first?.value else { return nil }
        return storage.get(id: id) as? T
    }
}
