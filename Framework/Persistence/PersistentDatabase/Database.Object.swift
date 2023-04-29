//
//  Database.Object.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.04.23.
//

import Foundation

extension Database {
    open class Object: PersistentData.Object, MergeableContent, Reflectable {
        @Serialized private(set) var values: [Key: TimeLine<ValueStorage>] = [:]
        @Serialized var added: Date?
        @Property var deleted: Bool = false

        var database: Database? { data as? Database }

        // MARK: - Changes

        var canChange: Bool { database?.timestamp == nil }

        func willChange() {
            objectWillChange.send()
            database?.willChange()
        }

        func didChange(timestamp: Date) {
            database?.didChange(timestamp: timestamp)
        }

        // MARK: - Timing

        var readingTimestamp: Date { database?.timestamp ?? Date.distantFuture }
        func writingTimestamp(_ timestamp: Date?) -> Date { database == nil ? Date.distantPast : timestamp ?? Date() }

        // MARK: - State

        public subscript<T>(_ type: T.Type, _ key: Key, timestamp timestamp: Date? = nil) -> T? where T: PersistentValue {
            get {
                values[key]?.timedValue(at: readingTimestamp)?[type: T.self]
            }
            set {
                guard canChange, newValue != self[type, key] else { return }
                let timestamp = writingTimestamp(timestamp)
                willChange()
                if values[key] == nil {
                    values[key] = TimeLine()
                }
                values[key]![type: T.self, at: timestamp] = newValue
                didChange(timestamp: timestamp)
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
