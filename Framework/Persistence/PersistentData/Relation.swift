//
//  PersistentDataRelationWrapper.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.12.22.
//

import Foundation

protocol PersistentRelationWrapper //: AnyObject
{}

extension PersistentData.Object {
    @propertyWrapper final class Relation<Target>: PersistentRelationWrapper where Target: PersistentData.Object {
        
        enum Direction {
            case reference, referenced
        }
        
        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
        public var wrappedValue: Target? {
            get { fatalError() }
            set { fatalError() }
        }

        private var _key: String?
        private var reverseKey: String?
        private var direction: Direction


        internal func getKey(from instance: PersistentData.Object) -> String {
            if let key = _key, !key.isEmpty { return key }

            _key = instance.getKey(for: self)
            return _key!
        }

        public init(_ key: String? = nil, reverse: String? = nil, direction: Direction) {
            _key = key
            reverseKey = reverse
            self.direction = direction
        }

        public static subscript<Enclosing: PersistentData.Object>(_enclosingInstance instance: Enclosing,
                                                                  wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Target?>,
                                                                  storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relation>)
            -> Target?
        {
            get {
                let storage = instance[keyPath: storageKeyPath]
                let key = storage.getKey(from: instance)
                let edges = storage.direction == .reference ? instance.outgoingEdges : instance.incomingEdges
                return edges
                    .filter { !$0.isDeleted }
                    .first(where: { $0[role: key] })?
                    .getOther(for: instance) as? Target
            }
            set {
                guard  newValue != Relation[_enclosingInstance: instance, wrapped: wrappedKeyPath, storage: storageKeyPath] else { return }
                let storage = instance[keyPath: storageKeyPath]
                let key = storage.getKey(from: instance)

                instance.objectWillChange.send()
                let timestamp = Date()
                instance.edges
                    .filter { !$0.isDeleted }
                    .filter { $0[role: key] }
                    .forEach { $0.isDeleted(true, timestamp: timestamp) }

                guard let newValue else { return }

                let edge = PersistentData.Edge(from: instance, to: newValue)
                instance.graph?.add(edge, timestamp: timestamp)

                edge[role: key, timestamp: timestamp] = true

                if let reverseKey = storage.reverseKey {
                    newValue.objectWillChange.send()
                    edge[role: reverseKey] = true
                }
            }
        }
    }
}
