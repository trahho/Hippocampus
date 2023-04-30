//
//  DatabaseDocument.Data.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.04.23.
//

import Foundation

public extension DatabaseDocument {
    class PersistentDataWrapper {
        func setup(url: URL, document: DatabaseDocument) {}
        var data: PersistentData! { nil }
    }

    @propertyWrapper
    final class Data<T>: PersistentDataWrapper where T: PersistentData {
        // MARK: - Initialization

        public init(wrappedValue: @autoclosure @escaping () -> T) {
            content = wrappedValue
        }

        // MARK: - Content

        var container: PersistentContainer<T>!
        var content: () -> T
        override var data: PersistentData { container.content }

        override func setup(url: URL, document: DatabaseDocument) {
            let content = content()
            content.document = document
            container = PersistentContainer(url: url, content: content)
        }

        // MARK: - Wrapping

        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
        public var wrappedValue: T {
            get { fatalError() }
            set { fatalError() }
        }

        public static subscript<Enclosing: DatabaseDocument>(_enclosingInstance instance: Enclosing,
                                                             wrapped _: ReferenceWritableKeyPath<Enclosing, T>,
                                                             storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Data>) -> T
        {
            get {
                let storage = instance[keyPath: storageKeyPath]
                return storage.container.content
            }
            set {}
        }
    }
}
