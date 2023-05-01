//
//  Database.Property.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.04.23.
//

import Foundation

extension Database.Object {
    @propertyWrapper final class Property<Value> where Value: Database.PersistentValue {
        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
        public var wrappedValue: Value {
            get { fatalError() }
            set { fatalError() }
        }
        
        private var defaultValue: (() -> Value)?
        
        private var key: String?
        
        internal func getKey(from instance: Database.Object) -> String {
            if let key { return key }
            
            guard let mirror = instance.mirror(for: Self.self).first(where: { $0.value === self }) else { fatalError("wrapper not found") }
            key = String(mirror.label!.dropFirst())
            
            return key!
        }
        
        public init(wrappedValue: @autoclosure @escaping () -> Value, _ key: String? = nil) {
            self.key = key
            defaultValue = wrappedValue
        }
        
        public init(_ key: String? = nil) {
            self.key = key
        }
        
        public static subscript<Enclosing: Database.Object>(_enclosingInstance instance: Enclosing,
                                                            wrapped _: ReferenceWritableKeyPath<Enclosing, Value>,
                                                            storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Property>) -> Value
        {
            get {
                let storage = instance[keyPath: storageKeyPath]
                let key = storage.getKey(from: instance)
                if let value = instance[Value.self, key] {
                    return value
                } else {
                    return storage.defaultValue!()
                }
            }
            set {
                let storage = instance[keyPath: storageKeyPath]
                let key = storage.getKey(from: instance)
                instance[Value.self, key] = newValue
            }
        }
    }
}
