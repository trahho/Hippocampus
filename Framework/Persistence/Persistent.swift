//
//  Persistent.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Combine
import Foundation

// fileprivate extension PersistentClass {
//    func getValue (for key: String) -> PersistentGraph.PersistentValue {
//        self[key]
//    }
//
//    func setValue(_ newValue: PersistentGraph.PersistentValue, for key: String) {
//        self[key] = newValue
//    }
// }

@propertyWrapper class Persistent<Value: Codable> {
    private var key: String
    private let defaultValue: (() -> Value)?
    
    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    //    init(wrappedValue defaultValue: @autoclosure @escaping () -> Value, key: String) {
    //        self.key = key
    //        self.defaultValue = defaultValue
    //    }
    //
    //    init(key: String) {
    //        self.key = key
    //        self.defaultValue = nil
    //    }
    
    init(optional key: String = "") {
        self.key = key
        defaultValue = nil
    }
    
    init(wrappedValue defaultValue: @autoclosure @escaping () -> Value, optional key: String = "") {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    func getKey(from instance: PersistentClass) -> String {
        guard key.isEmpty else { return key }
        
        let mirror = Mirror(reflecting: instance)
        let label = mirror.children.first { (_: String?, value: Any) in
            guard let property = value as? Persistent<Value>, property === self else { return false }
            return true
        }!.label!.dropFirst()
        key = String(label)
        return key
    }
    
    static subscript<EnclosingType: PersistentClass>(
        _enclosingInstance instance: EnclosingType,
        wrapped _: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Persistent>
    ) -> Value {
        get {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            if let value = instance[key] as? Value {
                return value
            } else {
                return storage.defaultValue!()
            }
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.getKey(from: instance)
            instance[key] = newValue
        }
    }

    //    var projectedValue: Binding<Value> {
    //        Binding<Value>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    //    }
}
