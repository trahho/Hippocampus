//
//  Database.Object.Object.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.04.23.
//

import Combine
import Foundation

extension DataStore.Object {
    @propertyWrapper final class Objects<Value> where Value: ObjectStore.Object {
        typealias ValueSet = Set<Value>
        typealias IDSet = Set<Value.ID>

        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
        public var wrappedValue: Value {
            get { fatalError() }
            set { fatalError() }
        }

        private var _key: String?

        var key: String {
            if let _key { return _key }

            guard let mirror = instance.mirror(for: Self.self).first(where: { $0.value === self }) else { fatalError("wrapper not found") }
            _key = String(mirror.label!.dropFirst())

            return _key!
        }

        private var cancellable: AnyCancellable?

        private var _value: ValueSet?
        var value: ValueSet {
            get {
                if let _value { return _value }
                guard
                    let database = instance.document,
                    let ids = instance[IDSet.self, key]
                else { return [] }

                _value = ids.compactMap { database[Value.self, $0] }.asSet
                return _value!
            }
            set {
                guard value != newValue else { return }
                let ids = newValue.map { $0.id }.asSet
                instance[IDSet.self, key] = ids
                _value = newValue
            }
        }

        private weak var _instance: DataStore.Object?
        private var instance: DataStore.Object {
            get { _instance! }
            set {
                guard newValue != _instance else { return }
                _instance = newValue
                cancellable = _instance!.objectWillChange.sink { [self] in
                    if instance.document != nil {
                        _value = nil
                    }
                }
            }
        }

        public static subscript<Enclosing: DataStore.Object>(_enclosingInstance instance: Enclosing,
                                                            wrapped _: ReferenceWritableKeyPath<Enclosing, Value>,
                                                            storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Objects>) -> Set<Value>
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

        public init(_ key: String? = nil) {
            self._key = key
        }
    }
}
