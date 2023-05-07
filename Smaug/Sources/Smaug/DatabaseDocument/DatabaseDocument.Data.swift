//
//  DatabaseDocument.Data.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.04.23.
//

import Combine
import Foundation

public extension DatabaseDocument {
    @propertyWrapper
    final class Data<T>: DataStorage where T: ObjectStore {
        // MARK: - Initialization

        public init(publishChange: Bool = true, commitOnChange: Bool = true) {
            self.commitOnChange = commitOnChange
            self.publishChange = publishChange
        }

        // MARK: - Content

        var container: ObjectStoreContainer<T>?
        var commitOnChange: Bool
        var publishChange: Bool
        var cancellable: AnyCancellable!

        var _content: T!
        public var content: T {
            get { container?.content ?? _content }
            set { container?.setContent(content: newValue) }
        }

        override func setup(url: URL, name: String, document: DatabaseDocument) {
            self.document = document
            _content = T()
            let url = url.appending(component: name + ".persistent")
            container = ObjectStoreContainer(document: document, url: url, content: content, commitOnChange: commitOnChange)
            if publishChange {
                cancellable = container!.objectWillChange.sink { document.objectWillChange.send() }
            }
        }

        override func initializeContent() {
            _content.document = document
            _content.setup()
        }

        override func start() {
            container!.start()
        }

        // MARK: - Storage

        override func getObject<T>(type: T.Type, id: T.ID) throws -> T? where T: ObjectStore.Object {
            try content.getObject(type: type, id: id)
        }

        override func getObjects<T>(type: T.Type) throws -> Set<T> where T: ObjectStore.Object {
            try content.getObjects(type: type)
        }

        override func addObject<T>(item: T) throws where T: ObjectStore.Object {
            try content.addObject(item: item)
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
                return storage.content
            }
            set {}
        }

        public var projectedValue: Data<T> {
            return self
        }
    }
}
