//
//  DatabaseDocument.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.04.23.
//

import Foundation

extension DatabaseDocument {
    enum Failure: Error {
        case typeNotFound
    }
}

open class DatabaseDocument: Reflectable, ObservableObject {
    private(set) var containerDocument: DatabaseDocument?

    // MARK: - Initialization

    public required init(url: URL, containerDocument: DatabaseDocument?) {
        self.containerDocument = containerDocument
        mirror(for: Storage.self).forEach {
            let name = String($0.label!.dropFirst())
            $0.value.setup(url: url, name: name, document: self)
        }
    }

    // MARK: - Transactional change

    private var _readingTimestamp: Date?
    private(set) var readingTimestamp: Date? {
        get { containerDocument?.readingTimestamp ?? _readingTimestamp }
        set {
            if let containerDocument {
                containerDocument.readingTimestamp = newValue
            } else {
                if newValue != nil, _readingTimestamp == nil {
                    _readingTimestamp = newValue
                }
                if newValue == nil, _readingTimestamp != nil {
                    _readingTimestamp = nil
                }
            }
        }
    }
    
    private var _writingTimestamp: Date?
    private(set) var writingTimestamp: Date? {
        get { containerDocument?.writingTimestamp ?? _writingTimestamp }
        set {
            if let containerDocument {
                containerDocument.writingTimestamp = newValue
            } else {
                if newValue != nil, _writingTimestamp == nil {
                    _writingTimestamp = newValue
                }
                if newValue == nil, _writingTimestamp != nil {
                    _writingTimestamp = nil
                }
            }
        }
    }

    func change(by change: () -> ()) {
        guard readingTimestamp == nil else { return }
        
        let didStart = writingTimestamp == nil
        if didStart {
            writingTimestamp = Date()
        }
        change()
        if didStart {
            writingTimestamp = nil
        }
    }

    // MARK: - Storage

    var storages: [DataStorage] {
        mirror(for: DataStorage.self).map { $0.value }
    }

    func getObject<T>(type: T.Type, id: T.ID) throws -> T? where T: ObjectStore.Object {
        for storage in storages {
            do {
                return try storage.getObject(type: type, id: id)
            } catch {}
        }
        if let containerDocument {
            return try containerDocument.getObject(type: type, id: id)
        }
        fatalError("Storage for \(type.self) not found")
    }

    func getObjects<T>(type: T.Type) throws -> Set<T> where T: ObjectStore.Object {
        for storage in storages {
            do {
                return try storage.getObjects(type: type)
            } catch {}
        }
        if let containerDocument {
            return try containerDocument.getObjects(type: type)
        }
        fatalError("Storage for \(type) not found")
    }

    func addObject<T>(item: T) throws where T: ObjectStore.Object {
        for storage in storages {
            do {
                try storage.addObject(item: item)
                return
            } catch {}
        }
        if let containerDocument {
            return try containerDocument.addObject(item: item)
        }
        fatalError("Storage for \(T.self) not found")
    }

    // MARK: - Function

    public subscript<T>(_ type: T.Type, _ id: T.ID) -> T? where T: ObjectStore.Object {
        try! getObject(type: type, id: id)
    }

    public subscript<T>(_ type: T.Type) -> Set<T> where T: ObjectStore.Object {
        try! getObjects(type: type)
    }

    public func add<T>(_ item: T) where T: ObjectStore.Object {
        change {
            try! addObject(item: item)
        }
    }

    public subscript<T>(_ type: T.Type, _ name: String) -> T? where T: DatabaseDocument {
        guard let mirror = mirror(for: Cache<T>.self).first else {
            return containerDocument?[type, name]
        }
        return mirror.value[name]
    }
}
