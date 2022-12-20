//
//  PersistentData.ValueWrapper.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.12.22.
//

import Foundation



@propertyWrapper final class Persistent<Value> where Value: Codable {
    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private var defaultValue: (() -> Value)?

    private var _key: String?

    internal func getKey(from instance: PersistentData.Object) -> String {
        if let _key { return _key }

        _key = instance.getKey(for: self)

        return _key!
    }

    public init(wrappedValue: @autoclosure @escaping () -> Value, _ key: String? = nil) {
        _key = key
        defaultValue = wrappedValue
    }

    public init(_ key: String? = nil) {
        _key = key
    }

    public static subscript<Enclosing: PersistentData.Object>(_enclosingInstance instance: Enclosing,
                                                              wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Value>,
                                                              storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Persistent>) -> Value
    {
        get {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            return instance[key] as? Value ?? storage.defaultValue!()
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            instance[key] = newValue
        }
    }
}
