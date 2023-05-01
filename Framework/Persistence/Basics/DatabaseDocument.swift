//
//  DatabaseDocument.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.04.23.
//

import Foundation

open class DatabaseDocument: Reflectable, ObservableObject {
    private(set) var containerDocument: DatabaseDocument?

    public required init(url: URL, containerDocument: DatabaseDocument?) {
        self.containerDocument = containerDocument
        mirror(for: PersistentWrapper.self).forEach {
            let name = String($0.label!.dropFirst())
            $0.value.setup(url: url, name: name, document: self)
        }
    }

    public subscript<T>(_ type: T.Type, _ id: T.ID) -> T? where T: PersistentData.Object {
        mirror(for: PersistentDataWrapper.self)
            .compactMap { $0.value.data.getObject(type, id) }
            .first
    }

    public subscript<T>(_ type: T.Type, _ name: String) -> T? where T: DatabaseDocument {
        guard let mirror = mirror(for: Cache<T>.self).first else {
            return containerDocument?[type, name]
        }
        return mirror.value[name]
    }
}
