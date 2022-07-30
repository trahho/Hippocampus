//
//  PersistentTransformable.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.05.22.
//

import Combine
import CoreData
import Foundation
import SwiftUI

@propertyWrapper
class PersistentTransformable<Value: CustomTransformable> {
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

    private static func registerObservation(observed: NSManagedObject, observer: PersistentTransformable) {
        guard observer.cancellable == nil else {
            return
        }
        observer.cancellable = observed.objectWillChange.sink { [weak observer] _ in
            observer?.currentValue = nil
        }
    }

    static subscript<EnclosingType: NSManagedObject>(
        _enclosingInstance instance: EnclosingType,
        wrapped _: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, PersistentTransformable>
    ) -> Value {
        get {
            let storage = instance[keyPath: storageKeyPath]

            registerObservation(observed: instance, observer: storage)

            if let value = storage.currentValue {
                return value
            } else {
                let key = storage.key
                if let data = instance.value(forKey: key) as? Value.TransformedValue {
                    let result = Value(transformableValue: data)
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
            registerObservation(observed: instance, observer: storage)
            let key = storage.key
            let data = newValue.transform()
            instance.setValue(data, forKey: key)
            storage.currentValue = newValue
        }
    }

//    var projectedValue: Binding<Value> {
//        Binding<Value>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
//    }
}
