//
//  Database.Object.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.04.23.
//

import Foundation

extension DataStore {
    open class Object: ObjectStore.Object, MergeableContent, Reflectable {
        @Serialized private(set) var values: [Key: TimeLine<ValueStorage>] = [:]
        @Serialized var added: Date?
        @Property var deleted: Bool = false

        var document: DatabaseDocument? { store?.document }

        // MARK: - Changes

        func change(by change: @escaping () -> ()) {
            let action = { [self] in
                objectWillChange.send()
                store?.willChange()
                change()
                store?.didChange()
            }

            if let document {
                if document.readingTimestamp != nil { return }
                document.change {
                    action()
                }
            } else {
                action()
            }
        }
        
        func willChange() {
            objectWillChange.send()
        }

        // MARK: - Timing

        var readingTimestamp: Date { document?.readingTimestamp ?? Date.distantFuture }
        var writingTimestamp: Date { document?.writingTimestamp ?? Date.distantPast }

        // MARK: - State

        public subscript<T>(_ type: T.Type, _ key: Key, timestamp timestamp: Date? = nil) -> T? where T: PersistentValue {
            get {
                values[key]?.timedValue(at: readingTimestamp)?[type: T.self]
            }
            set {
                guard newValue != self[type, key] else { return }
                change { [self] in
                    if values[key] == nil {
                        values[key] = TimeLine()
                    }
                    values[key]![type: T.self, at: writingTimestamp] = newValue
                }
            }
        }

        public func value(key: Key) -> (any PersistentValue)? {
            values[key]?.timedValue(at: readingTimestamp)?.value
        }

        // MARK: - Merging

        public func merge(other: MergeableContent) throws {
            guard let other = other as? Self, other.id == id else { return }

            willChange()

            if let added, let otherAdded = other.added, added < otherAdded { self.added = other.added }

            Set(values.keys).intersection(Set(other.values.keys))
                .forEach { key in
                    values[key] = values[key]!.merged(with: other.values[key]!)
                }

            Set(other.values.keys).subtracting(Set(values.keys))
                .forEach { key in
                    values[key] = other.values[key]!
                }
        }
    }
}
