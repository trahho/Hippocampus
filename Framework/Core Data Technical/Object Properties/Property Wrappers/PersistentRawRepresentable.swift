//
//  PersistentEnum.swift
//  Hippocampus
//
//  Created by Guido Kühn on 09.05.22.
//

import CoreData
import Foundation
import SwiftUI

@propertyWrapper
class PersistentRawRepresentable<Value: RawRepresentable> {
    private let key: String
    private let defaultValue: () -> Value

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    init(wrappedValue defaultValue: @autoclosure @escaping () -> Value, key: String) {
        self.key = key
        self.defaultValue = defaultValue
    }

    static subscript<EnclosingType: NSManagedObject>(
        _enclosingInstance instance: EnclosingType,
        wrapped _: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, PersistentRawRepresentable>
    ) -> Value {
        get {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.key
            if let value = instance.value(forKey: key) as? Value.RawValue, let result = Value(rawValue: value) {
                return result
            } else {
                return storage.defaultValue()
            }
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.key
            instance.setValue(newValue.rawValue, forKey: key)
        }
    }

//    var projectedValue: Binding<Value> {
//        Binding<Value>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
//    }
}
