//
//  PersistentDataRelationWrapper.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.12.22.
//

import Combine
import Foundation

protocol PersistentRelationWrapper //: AnyObject
{}

extension PersistentModel.Object {
    @propertyWrapper final class Relation<Target> where Target: PersistentModel.Object {
        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
        public var wrappedValue: Target? {
            get { fatalError() }
            set { fatalError() }
        }

        private var cancellable: AnyCancellable?

        private var _value: Target?
        var value: Target? {
            get {
                if let _value { return _value }
                guard
                    let graph = instance.graph,
                    let id = instance[Target.ID.self, key],
                    let target = graph.nodeStorage[id] as? Target
                else { return nil }

                _value = target
                return _value
            }
            set {
                guard value != newValue else { return }
                instance[Target.ID.self, key] = newValue?.id
                print ("setting value")
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
                        print("clearing value")
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
                                                                  wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Target?>,
                                                                  storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relation>)
            -> Target?
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
}

// extension PersistentData.Object {
//    typealias Relation1a<Target: PersistentData.Object> = PersistentData.Relation1<PersistentData.Object, Target>
// }

// extension PersistentData {
//    @propertyWrapper final class Relation1<Enclosing, Target>: PersistentRelationWrapper where Enclosing: PersistentData.Object, Target: PersistentData.Object {
//        enum Direction {
//            case reference, referenced
//        }
//
//        typealias ReverseWrapper = Relation1<PersistentData.Object, Enclosing>
//        typealias TargetKeyPathBuilder = () -> KeyPath<Target?, ReverseWrapper>
//
//        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
//        public var wrappedValue: Target? {
//            get { fatalError() }
//            set { fatalError() }
//        }
//
//        private var targets: Set<Target> = []
//
//        private var _key: String?
//        private var reverseKey: TargetKeyPathBuilder?
//        private var reverseWrapper: ReverseWrapper?
////        private var direction: Direction
//
//        internal func getKey(from instance: Enclosing) -> String {
//            if let key = _key, !key.isEmpty { return key }
//
//            _key = instance.getKey(for: self)
//            return _key!
//        }
//
//        public init(_ key: String? = nil, reverse: @autoclosure @escaping TargetKeyPathBuilder) {
//            _key = key
//            reverseKey = reverse
////            self.direction = direction
//        }
//
//        public init(_ key: String? = nil) {
//            _key = key
////            self.direction = direction
//        }
//
//        public static subscript(_enclosingInstance instance: Enclosing,
//                                wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Target?>,
//                                storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relation1>)
//            -> Target?
//        {
//            get {
//                let storage = instance[keyPath: storageKeyPath]
//                let key = storage.getKey(from: instance)
//                let values = instance[Set<Target.ID>.self, key] ?? []
//                return nil
//            }
//            set {
//                let storage = instance[keyPath: storageKeyPath]
//                let key = storage.getKey(from: instance)
//                if let id = newValue?.id {
//                    instance[Set<Target.ID>.self, key] = [id]
//                } else {
//                    instance[Set<Target.ID>.self, key] = []
//                }
//                if let reverseWrapper = storage.reverseWrapper {
//                    reverseWrapper
//                }
//                if let reverseKey = storage.reverseKey {
//                    let wrapper = newValue[keyPath: reverseKey()]
//                }
//            }
//        }
//
//        var projectedValue: Relation1 {
//            self
//        }
//    }
// }
