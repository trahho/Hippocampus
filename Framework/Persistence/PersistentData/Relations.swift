//
//  Relations.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.12.22.
//

import Foundation

@propertyWrapper final class Relations<Target>: PersistentRelationWrapper where Target: PersistentData.Object {
    typealias TargetSet = Set<Target>

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    public var wrappedValue: Set<Target> {
        get { fatalError() }
        set { fatalError() }
    }

    private var _key: String?
    private var inversekey: String?

    internal func getKey(from instance: PersistentData.Object) -> String {
        if let key = _key, !key.isEmpty { return key }

        _key = instance.getKey(for: self)
        return _key!
    }

    public init(_ key: String? = nil, inverse: String? = nil) {
        _key = key
        inversekey = inverse
    }

    public static subscript<Enclosing: PersistentData.Object>(_enclosingInstance instance: Enclosing,
                                                              wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, TargetSet>,
                                                              storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relations>)
        -> TargetSet
    {
        get {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            return instance.edges.filter { $0[role: key] }.map { $0.getOther(for: instance) as! Target }.asSet
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            let change = {
                let currentValue = Relations[_enclosingInstance: instance, wrapped: wrappedKeyPath, storage: storageKeyPath]
                let added = newValue.subtracting(currentValue)
                let removed = currentValue.subtracting(newValue)

                removed
                    .flatMap { item in
                        instance.edges.filter { edge in
                            edge[role: key] && edge.getOther(for: instance) == item
                        }
                    }
                    .forEach { edge in
                        if storage.inversekey != nil {
                            edge.getOther(for: instance).objectWillChange.send()
                        }
                        edge.isDeleted = true
                    }

                added
                    .forEach {
                        let edge = PersistentData.Edge(from: instance, to: $0)
                        edge[role: key] = true
                        if let inversekey = storage.inversekey {
                            $0.objectWillChange.send()
                            edge[role: inversekey] = true
                        }
                        instance.graph?.add(edge)
                    }
            }

            if let graph = instance.graph {
                graph.change(change)
            }
            else {
                change()
            }
        }
    }
}
