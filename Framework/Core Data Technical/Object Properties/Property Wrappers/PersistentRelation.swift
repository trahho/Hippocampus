//
//  PersistentRelation.swift
//  PoCCoreDataDirectAccess
//
//  Created by Guido Kühn on 30.04.22.
//

import Foundation

import CoreData
import Foundation
import SwiftUI

@propertyWrapper
class PersistentRelation<Element> where Element: NSManagedObject {
    private let key: String

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: Set<Element> {
        get { fatalError() }
        set { fatalError() }
    }

    init<T: DataFieldKey>(key: T) {
        self.key = key.rawValue
    }

    static subscript<EnclosingType: NSManagedObject>(
        _enclosingInstance instance: EnclosingType,
        wrapped _: ReferenceWritableKeyPath<EnclosingType, Set<Element>>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, PersistentRelation>
    ) -> Set<Element> {
        get {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.key
            let result = instance.mutableSetValue(forKey: key) as? Set<Element> ?? []
            return result
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            let key = storage.key
            let relations = instance.mutableSetValue(forKey: key)
            let set = relations as? Set<Element> ?? []

            set.filter { !newValue.contains($0) }
                .forEach { relations.remove($0) }

            newValue.filter { !set.contains($0) }
                .forEach { relations.add($0) }
        }
    }

//    var projectedValue: Binding<Value> {
//        Binding<Value>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
//    }
}
