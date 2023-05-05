//
//  PersistentData.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

public extension ObjectStore {
    @propertyWrapper
    final class Objects<T>: ObjectsStorageBase<T> where T: Object {
        public var wrappedValue: Set<T> {
            get {
                Set(storage.values)
            }
            set {}
        }
    }
}
