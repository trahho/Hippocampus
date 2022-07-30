//
//  Observed.swift
//  Hippocampus
//
//  Created by Guido Kühn on 07.05.22.
//

import Combine
import Foundation

/// Promotes the change from the observed object to the owner.
///
/// It serves to implement a view model with nested observable objects. Normally SwiftUI does not notice the changes in the nested objects.
/// The `Observed` property wrapper watches the object, and when `objectWillChange` is sent, it sends the `objectWillChange` of the owner.
@propertyWrapper
class Observed<Value: ObservableObject> {
    typealias Initializer = () -> Value

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private var cancellable: AnyCancellable?
    private var observedInstance: Value?
    private var initialValue: (() -> Value)?

    /// Initializes the property wrapper with the declared value.
    ///
    /// - Parameters:
    ///     - wrappedValue: The declared value
    @inlinable public init(wrappedValue thunk: @autoclosure @escaping () -> Value) {
        initialValue = thunk
    }

    /// Initializes the property wrapper with a value from the `Injector`.
    ///
    /// - Parameters:
    ///     - injectedFrom: The keypath to the injected value.
    @inlinable public init(_ keyPath: WritableKeyPath<Injector, Value>) {
        initialValue = { Injector[keyPath] }
    }

    @inlinable public init() {}

    private static func registerObservation<Observer: ObservableObject, Observed: ObservableObject>(observed: Observed, observer: Observer, observedObject: Any) -> AnyCancellable {
        observed.objectWillChange.sink { [weak observer] _ in
            if let receiver = observer as? ObservedChangesReceiver {
                receiver.willChange(observedObject: observedObject)
                return
            }
            guard let publisher = observer?.objectWillChange as? Combine.ObservableObjectPublisher else {
                return
            }
            publisher.send()
        }
    }

    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped _: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Observed>
    ) -> Value {
        get {
            let storage = instance[keyPath: storageKeyPath]
            if let result = storage.observedInstance {
                return result
            } else {
                let result = storage.initialValue!()
                storage.observedInstance = result
                storage.cancellable = registerObservation(observed: result, observer: instance, observedObject: storage)
                return result
            }
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            if let receiver = instance as? ObservedChangesReceiver {
                receiver.willChange(observedObject: storage)
            } else if let publisher = instance.objectWillChange as? Combine.ObservableObjectPublisher {
                publisher.send()
            }
            storage.observedInstance = newValue
            storage.cancellable = registerObservation(observed: newValue, observer: instance, observedObject: storage)
        }
    }
}
