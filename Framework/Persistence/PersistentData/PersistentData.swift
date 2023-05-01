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

    // MARK: - Enclosing

    public var objectDidChange: ObjectDidChangePublisher = .init()
    var document: DatabaseDocument!

    // MARK: - Initialisation

    public required init() {}

    // MARK: - Persistence

//    public func setup() -> Self {
//        self
//    }

    public func restore() {
        let mirror = mirror(for: StorageWrapper.self)
        mirror.forEach {
            $0.value.setContainer(container: self)
        }
    }

    public func merge(other: MergeableContent) throws {
        guard let other = other as? Self else { throw MergeableContentMergeError.wrongMatch }

        for (own, other) in zip(mirror(for: StorageWrapper.self), other.mirror(for: StorageWrapper.self)) {
            try own.value.merge(other: other.value)
            own.value.setContainer(container: self)
        }
    }

    // MARK: - Function

    public func add<T>(_ item: T) where T: Object {
        guard
            let storage = mirror(for: Objects<T>.self).first?.value,
            storage.get(id: item.id) == nil
        else { return }

        objectWillChange.send()
        storage.add(item: item)
        item.data = self
        objectDidChange.send()
    }

    public func getObject<T>(_ type: T.Type, _ id: T.ID) -> T? where T: Object {
        guard let storage = mirror(for: Objects<T>.self).first?.value else { return nil }
        return storage.get(id: id) as? T
    }

    public subscript<T>(_ type: T.Type, _ id: T.ID) -> T? where T: Object {
        self.getObject(type, id) ?? document[type, id]
    }
}
