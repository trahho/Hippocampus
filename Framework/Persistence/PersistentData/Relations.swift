//
//  Relations.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.12.22.
//

import Foundation

@propertyWrapper final class Relations<Target>: PersistentRelationWrapper where Target: PersistentData.Object {
    typealias TargetSet = Set<Target>

    enum Direction {
        case reference, referenced
    }

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    public var wrappedValue: Set<Target> {
        get { fatalError() }
        set { fatalError() }
    }

    private var key: String?
    private var reverseKey: String?
    private var direction: Direction

    internal func getKey(from instance: PersistentData.Object) -> String {
        if let key, !key.isEmpty { return key }

        key = instance.getKey(for: self)
        return key!
    }

    public init(_ key: String? = nil, reverse: String? = nil, direction: Direction = .reference) {
        self.key = key
        self.reverseKey = reverse
        self.direction = direction
    }

    public static subscript<Enclosing: PersistentData.Object>(_enclosingInstance instance: Enclosing,
                                                              wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, TargetSet>,
                                                              storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relations>)
        -> TargetSet
    {
        get {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            let edges = storage.direction == .reference ? instance.outgoingEdges : instance.incomingEdges
            return edges
                .filter { $0[role: key] }
                .map { $0.getOther(for: instance) as! Target }
                .asSet
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)

            let currentValue = Relations[_enclosingInstance: instance, wrapped: wrappedKeyPath, storage: storageKeyPath]
            let added = newValue.subtracting(currentValue)
            let removed = currentValue.subtracting(newValue)

            let timestamp = Date()
//            let edges = storage.direction == .reference ? instance.outgoingEdges : instance.incomingEdges
            removed
                .flatMap { item in
                    instance.edges.filter { edge in
                        edge[role: key] && edge.getOther(for: instance) == item
                    }
                }
                .forEach { edge in
                    if storage.reverseKey != nil {
                        edge.getOther(for: instance).objectWillChange.send()
                    }
                    edge.isDeleted(true, timestamp: timestamp)
                }

            added
                .forEach { item in
                    let edge = storage.direction == .reference ? PersistentData.Edge(from: instance, to: item) : PersistentData.Edge(from: item, to: instance)
                    edge[role: key, timestamp: timestamp] = true
                    if let inversekey = storage.reverseKey {
                        item.objectWillChange.send()
                        edge[role: inversekey, timestamp: timestamp] = true
                    }
                    instance.graph?.add(edge, timestamp: timestamp)
                }
        }
    }
}
