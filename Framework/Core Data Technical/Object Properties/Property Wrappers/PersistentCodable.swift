//
//  PersistentCodable.swift
//  PoCCoreDataDirectAccess
//
//  Created by Guido Kühn on 30.04.22.
//

import Combine
import CoreData
import Foundation
import SwiftUI

@propertyWrapper
class PersistentCodable<Value: Codable> {
    private let key: String
    private let defaultValue: () -> Value
    private var currentValue: Value?
    private var cancellable: AnyCancellable?

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    init<T: DataFieldKey>(wrappedValue defaultValue: @autoclosure @escaping () -> Value, key: T) {
        self.key = key.key
        self.defaultValue = defaultValue
    }

    private static func registerObservation(observed: NSManagedObject, observer: PersistentCodable) -> AnyCancellable {
        observed.objectWillChange.sink { [weak observer] _ in
            observer?.currentValue = nil
        }
    }

    static subscript<EnclosingType: NSManagedObject>(
        _enclosingInstance instance: EnclosingType,
        wrapped _: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, PersistentCodable>
    ) -> Value {
        get {
            let storage = instance[keyPath: storageKeyPath]
            if storage.cancellable == nil {
                storage.cancellable = registerObservation(observed: instance, observer: storage)
            }
            if let value = storage.currentValue {
                return value
            } else {
                let key = storage.key
                if let data = instance.value(forKey: key) as? Data,
                   let result = try? JSONDecoder().decode(Value.self, from: data)
                {
                    storage.currentValue = result
                    return result
                } else {
                    let defaultValue = storage.defaultValue()
                    storage.currentValue = defaultValue
                    return defaultValue
                }
            }
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.key
            let data = try! JSONEncoder().encode(newValue)
            instance.setValue(data, forKey: key)
            storage.currentValue = newValue
        }
    }

//    var projectedValue: Binding<Value> {
//        Binding<Value>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
//    }
}
