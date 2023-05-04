//
//  PersistentData.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

open class ObjectStore: PersistentContent, Serializable, RestorableContent, MergeableContent, ContentContainer, ObservableObject, Reflectable {
    // MARK: - Types

    enum Fault: Error {
        case wrongMatch
        case mergeFailed
    }
    
    var document: DatabaseDocument!

    // MARK: - Enclosing

    public var objectDidChange: ObjectDidChangePublisher = .init()

    // MARK: - Initialisation

    public required init() {}

    // MARK: - Persistence

    func willChange() {
        objectWillChange.send()
    }

    func didChange() {
        objectDidChange.send()
    }

    public func restore() {
        let mirror = mirror(for: ObjectsStorage.self)
        mirror.forEach {
            $0.value.setStore(store: self)
        }
    }

    public func merge(other: MergeableContent) throws {
        guard let other = other as? Self else { throw MergeableContentMergeError.wrongMatch }

        for (own, other) in zip(mirror(for: ObjectsStorage.self), other.mirror(for: ObjectsStorage.self)) {
            try own.value.merge(other: other.value)
            own.value.setStore(store: self)
        }
    }

    // MARK: - Storage

    func storage<T>(type: T.Type) -> Objects<T>? {
        mirror(for: Objects<T>.self).first?.value
    }

    func getObject<T>(type: T.Type, id: T.ID) throws -> T? where T: ObjectStore.Object {
        guard let storage = storage(type: type) else { throw DatabaseDocument.Failure.typeNotFound }
        return storage.getObject(id: id)
    }

    func getObjects<T>(type: T.Type) throws -> Set<T> where T: ObjectStore.Object {
        guard let storage = storage(type: type) else { throw DatabaseDocument.Failure.typeNotFound }
        return storage.getObjects()
    }

    func addObject<T>(item: T) throws where T: ObjectStore.Object {
        guard let storage = storage(type: T.self) else { throw DatabaseDocument.Failure.typeNotFound }
        guard storage.getObject(id: item.id) == nil else { return }
        
        objectWillChange.send()
        storage.addObject(item: item)
        objectDidChange.send()
    }
}
