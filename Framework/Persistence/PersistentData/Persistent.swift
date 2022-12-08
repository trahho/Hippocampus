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

// class PersistentPropertyWrapper<Value> {
//    private var key: String
//    internal let defaultValue: (() -> Value)?
//
//    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
//    var wrappedValue: Value {
//        get { fatalError() }
//        set { fatalError() }
//    }
//
//
//    init(_ key: String = "") {
//        self.key = key
//        defaultValue = nil
//    }
//
//    init(wrappedValue defaultValue: @autoclosure @escaping () -> Value, _ key: String = "") {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//
//    func getKey(from instance: PersistentData.Object) -> String {
//        guard key.isEmpty else { return key }
//
//        let mirror = Mirror(reflecting: instance)
//        let label = mirror.children.first { (_: String?, value: Any) in
//            guard let property = value as? PersistentPropertyWrapper<Value>, property === self else { return false }
//            return true
//        }!.label!.dropFirst()
//        key = String(label)
//        return key
//    }
// }

extension PersistentData.Object {
    func getKey<T: AnyObject>(for wrapper: T) -> String {
        let mirror = Mirror(reflecting: self)
        let label = mirror.children.first { (_: String?, value: Any) in
            guard let property = value as? T, property === wrapper else { return false }
            return true
        }!.label!.dropFirst()
        let key = String(label)
        return key
    }
}

@propertyWrapper class Persistent<Value> where Value: Codable {
    private var key: String
    internal let defaultValue: (() -> Value)?

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    init(_ key: String = "") {
        self.key = key
        defaultValue = nil
    }

    init(wrappedValue defaultValue: @autoclosure @escaping () -> Value, _ key: String = "") {
        self.key = key
        self.defaultValue = defaultValue
    }

    func ensureKey(for instance: PersistentData.Object) {
        guard key.isEmpty else { return }
        key = instance.getKey(for: self)
    }

    static subscript<EnclosingType: PersistentData.Object>(
        _enclosingInstance instance: EnclosingType,
        wrapped _: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Persistent>
    ) -> Value {
        get {
            let storage = instance[keyPath: storageKeyPath]
            storage.ensureKey(for: instance)
            if let value = instance[storage.key] as? Value {
                return value
            } else {
                return storage.defaultValue!()
            }
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            storage.ensureKey(for: instance)
            instance[storage.key] = newValue
        }
    }

    //    var projectedValue: Binding<Value> {
    //        Binding<Value>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    //    }
}

//@propertyWrapper class Reference<Value> where Value: PersistentData.Object {}

// class Reference<Value>: PersistentPropertyWrapper<Value> where Value: PersistentData.Object {
//    var currentValue: Value?
//
////    init(key: String = "") {
////        self.key = key
////        defaultValue = nil
////    }
//
//    init(reference: KeyPath<PersistentData.Object, Reference<Value>>) {
//        super.init()
//    }
//
//    static func referenceRole<A, B>(a _: A, b _: B) -> String {
//        let aName = String(describing: type(of: A.self))
//        let bName = String(describing: type(of: B.self))
//        return [aName, bName]
//            .sorted(by: <)
//            .joined(separator: "->")
//    }
//
//    static func isReferenceTo<A, B>(a _: A, b _: B) -> Bool {
//        let aName = String(describing: type(of: A.self))
//        let bName = String(describing: type(of: B.self))
//        return aName < bName
//    }
//
////    static subscript<EnclosingType: PersistentData.Object>(
////        _enclosingInstance instance: EnclosingType,
////        wrapped _: ReferenceWritableKeyPath<EnclosingType, Value>,
////        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Reference>
////    ) -> Value {
////        get {
////            let storage = instance[keyPath: storageKeyPath]
////            let key = storage.getKey(from: instance)
////            if let value = storage.currentValue {
////                return value
////            }
//////            if let reference = instance.node.
//////            if let referenceId = instance[key] as? PersistentData.Member.ID,
//////               let edge = instance.graph?.edges[referenceId]
//////            {
//////
//////                storage.currentValue = value
//////                return value
//////            }
////            return storage.defaultValue!()
////        }
////        set {
////            let storage = instance[keyPath: storageKeyPath]
////            let key = storage.getKey(from: instance)
////            if let graph = instance.node.graph {}
////            if let currentValue = storage.currentValue {} currentValue == newValue {
////                return
////            }
////
////            instance[key] = newValue
////        }
////    }
// }
