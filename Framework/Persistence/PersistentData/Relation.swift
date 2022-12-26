//
//  PersistentDataRelationWrapper.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.12.22.
//

import Foundation

protocol PersistentRelationWrapper//: AnyObject
{}

@propertyWrapper final class Relation<Target>: PersistentRelationWrapper where Target: PersistentData.Object {
    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    public var wrappedValue: Target? {
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
                                                              wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Target?>,
                                                              storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relation>)
        -> Target?
    {
        get {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            guard let result = instance.edges.first(where: { $0[role: key] })?.getOther(for: instance) else { return nil }
            return result as? Target
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            let change = {
                instance.edges
                    .filter { $0[role: key] }
                    .forEach { $0.isDeleted = true }

                guard let newValue else { return }

                let edge = PersistentData.Edge(from: instance, to: newValue)
                instance.graph?.add(edge)

                edge[role: key] = true

                if let inversekey = storage.inversekey {
                    newValue.objectWillChange.send()
                    edge[role: inversekey] = true
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
