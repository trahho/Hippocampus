//
//  DatabaseDocument.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.04.23.
//

import Foundation

open class DatabaseDocument: Reflectable {
    init(url: URL) {
        mirror(for: PersistentDataWrapper.self).forEach {
            let name = String($0.label!.dropFirst())
            let url = url.appendingPathComponent(name + ".persistent")
            $0.value.setup(url: url, document: self)
        }
    }

    public subscript<T>(_ type: T.Type, _ id: T.ID) -> T? where T: PersistentData.Object {
        mirror(for: PersistentDataWrapper.self).compactMap { $0.value.data.getObject(type, id) }.first
    }
}
