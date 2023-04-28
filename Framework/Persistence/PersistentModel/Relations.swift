//
//  Relations.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.12.22.
//

import Combine
import Foundation

extension PersistentModel.Object {
    @propertyWrapper final class Relations<Target> where Target: PersistentModel.Object {
        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
        public var wrappedValue: TargetSet {
            get { fatalError() }
            set { fatalError() }
        }

        typealias TargetSet = Set<Target>
        typealias TargetIDSet = Set<Target.ID>

        private var cancellable: AnyCancellable?

        private var _value: TargetSet?
        var value: TargetSet {
            get {
                if let _value { return _value }
                guard
                    let graph = instance.graph,
                    let ids = instance[TargetIDSet.self, key]
                else { return [] }

                _value = ids.compactMap({ graph.nodeStorage[$0] as? Target }).asSet
                return _value!
            }
            set {
                guard value != newValue else { return }
                instance[TargetIDSet.self, key] = newValue.map({ $0.id }).asSet
                _value = newValue
            }
        }

        private weak var _instance: PersistentModel.Object?
        private var instance: PersistentModel.Object {
            get { _instance! }
            set {
                guard newValue != _instance else { return }
                _instance = newValue
                cancellable = _instance!.objectWillChange.sink { [self] in
                    if instance.graph != nil {
                        _value = nil
                    }
                }
            }
        }

        private var _key: String?
        var key: String {
            if let _key, !_key.isEmpty { return _key }

            _key = instance.getKey(for: self)
            return _key!
        }

        public init(_ key: String? = nil) {
            self._key = key
        }

        public static subscript<Enclosing: PersistentModel.Object>(_enclosingInstance instance: Enclosing,
                                                                  wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, TargetSet>,
                                                                  storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relations>)
            -> TargetSet
        {
            get {
                let storage = instance[keyPath: storageKeyPath]
                storage.instance = instance
                return storage.value
            }
            set {
                let storage = instance[keyPath: storageKeyPath]
                storage.instance = instance
                storage.value = newValue
            }
        }
    }

//    @propertyWrapper final class Relations_<Target>: PersistentRelationWrapper where Target: PersistentData.Object {
//        typealias TargetSet = Set<Target>
//
//
//        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
//        public var wrappedValue: Set<Target> {
//            get { fatalError() }
//            set { fatalError() }
//        }
//
//        private var key: String?
//        private var reverseKey: String?
//        private var direction: Direction
//
//        internal func getKey(from instance: PersistentData.Object) -> String {
//            if let key, !key.isEmpty { return key }
//
//            key = instance.getKey(for: self)
//            return key!
//        }
//
//        public init(_ key: String? = nil, reverse: String? = nil, direction: Direction = .reference) {
//            self.key = key
//            reverseKey = reverse
//            self.direction = direction
//        }
//
//        public static subscript<Enclosing: PersistentData.Object>(_enclosingInstance instance: Enclosing,
//                                                                  wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, TargetSet>,
//                                                                  storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relations_>)
//            -> TargetSet
//        {
//            get {
//                let storage = instance[keyPath: storageKeyPath]
//                let key = storage.getKey(from: instance)
//                let edges = storage.direction == .reference ? instance.outgoingEdges : instance.incomingEdges
//                return edges
//                    .filter { !$0.isDeleted }
//                    .filter { $0[role: key] }
//                    .map { $0.getOther(for: instance) as! Target }
//                    .asSet
//            }
//            set {
//                let storage = instance[keyPath: storageKeyPath]
//                let key = storage.getKey(from: instance)
//
//                let currentValue = Relations[_enclosingInstance: instance, wrapped: wrappedKeyPath, storage: storageKeyPath]
//                let added = newValue.subtracting(currentValue)
//                let removed = currentValue.subtracting(newValue)
//
//                let timestamp = Date()
//                //            let edges = storage.direction == .reference ? instance.outgoingEdges : instance.incomingEdges
//                instance.objectWillChange.send()
//                removed
//                    .flatMap { item in
//                        instance.edges.filter { edge in
//                            edge[role: key] && edge.getOther(for: instance) == item
//                        }
//                    }
//                    .forEach { edge in
//                        if storage.reverseKey != nil {
//                            edge.getOther(for: instance).objectWillChange.send()
//                        }
//                        edge.isDeleted(true, timestamp: timestamp)
//                    }
//
//                added
//                    .forEach { item in
//                        let edge = storage.direction == .reference ? PersistentData.Edge(from: instance, to: item) : PersistentData.Edge(from: item, to: instance)
//                        edge[role: key, timestamp: timestamp] = true
//                        if let inversekey = storage.reverseKey {
//                            item.objectWillChange.send()
//                            edge[role: inversekey, timestamp: timestamp] = true
//                        }
//                        instance.graph?.add(edge, timestamp: timestamp)
//                    }
//            }
//        }
//    }
}
