//
//  PersistentData.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

open class PersistentDynamicData: PersistentData {}

open class PersistentData: PersistentContent, Serializable, RestorableContent, MergeableContent, ObservableObject {
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

    public func restore(content: RestorableContent?) {
        let mirror = mirror(for: RestorableContent.self)
        mirror.forEach {
            $0.value.restore(content: self)
        }
    }

    public func merge(other: MergeableContent) throws {
        guard let other = other as? Self else { throw MergeableContentMergeError.wrongMatch }

        for (own, other) in zip(mirror(for: MergeableContent.self), other.mirror(for: MergeableContent.self)) {
            try own.value.merge(other: other.value)
            if let restorable = own.value as? RestorableContent { restorable.restore(content: self) }
        }
    }

//    func merge<T>(own: [T.ID: T], other: [T.ID: T]) where T: Item {
//        Set(own.keys).intersection(Set(other.keys))
//            .forEach { key in
//                own[key]!.merge(other: other[key]!)
//            }
//
//        Set(other.keys).subtracting(Set(own.keys))
//            .forEach { key in
//                let edge = other[key]!
//                self[key] = edge
//                edge.adopt(timestamp: nil)
//            }
//    }

//    public func merge(other: PersistentData) throws {
//        guard type(of: other) == type(of: self) else { throw Fault.wrongMatch }
//        objectWillChange.send()
//
//        let selfMirror = mirror(for: Storage.self)
//        let otherMirror = other.mirror(for: Storage.self)
//    }

    // MARK: - Function

    private func mirror<T>(for _: T.Type) -> [(label: String?, value: T)] {
        var result: [(label: String?, value: T)] = []
        var mirror: Mirror? = Mirror(reflecting: self)
        repeat {
            guard let children = mirror?.children else { break }
            for child in children {
                if let value = child.value as? T {
                    result.append((label: child.label, value: value))
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
        return result
    }

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
