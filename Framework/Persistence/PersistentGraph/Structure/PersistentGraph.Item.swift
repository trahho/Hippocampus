//
//  PersistentGraph.Member.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

extension PersistentGraph {
    open class Item: PersistentObject, ObservableObject {
        @Serialized private(set) var rolesValue = TimeLine(Set<Role>())
        @Serialized private(set) var deletedValue = TimeLine()
        @Serialized private(set) var values: [Key: TimeLine] = [:]
        @Serialized var added: Date?

        var graph: PersistentGraph!
        var readingTimestamp: Date { graph?.timestamp ?? Date.distantFuture }
        func writingTimestamp(_ timestamp: Date?) -> Date { graph == nil ? Date.distantPast : timestamp ?? Date() }
        var canChange: Bool { graph?.timestamp == nil }

        // MARK: - State

        public var isDeleted: Bool {
            deletedValue[type: Bool.self, at: readingTimestamp] ?? false
        }

        public func isDeleted(_ value: Bool, timestamp: Date? = nil) {
            guard canChange else { return }
            objectWillChange.send()
            deletedValue[type: Bool.self, at: writingTimestamp(timestamp)] = value
            graph?.publishDidChange()
        }

        public subscript(role role: Role, timestamp timestamp: Date? = nil) -> Bool {
            get {
                rolesValue[type: Set<Role>.self, at: readingTimestamp]?.contains(role) ?? false
            }
            set {
                guard canChange else { return }

                var newRoles = rolesValue[type: Set<Role>.self, at: readingTimestamp] ?? Set<Role>()
                if newValue == true, !newRoles.contains(role) {
                    objectWillChange.send()
                    newRoles.insert(role)
                    rolesValue[type: Set<Role>.self, at: writingTimestamp(timestamp)] = newRoles
                    graph?.publishDidChange()
                } else if newValue == false, newRoles.contains(role) {
                    objectWillChange.send()
                    newRoles.remove(role)
                    rolesValue[type: Set<Role>.self, at: writingTimestamp(timestamp)] = newRoles
                    graph?.publishDidChange()
                }
            }
        }

        public subscript<T>(_ type: T.Type, _ key: Key, timestamp timestamp: Date? = nil) -> T? where T: PersistentValue {
            get {
                values[key]?.timedValue(at: readingTimestamp)?[type: T.self]
            }
            set {
                guard canChange, newValue != self[type, key] else { return }

                objectWillChange.send()
                if values[key] == nil {
                    values[key] = TimeLine()
                }
                values[key]![type: T.self, at: writingTimestamp(timestamp)] = newValue
                graph?.publishDidChange()
            }
        }

        public func currentValue(key: Key) -> (any PersistentValue)? {
            values[key]?.timedValue(at: readingTimestamp)?.value
        }

        // MARK: - Management

        public var isActive: Bool {
            if let added, added <= readingTimestamp, !isDeleted {
                return true
            } else {
                return false
            }
        }

        func adopt(timestamp _: Date?) {}

        func reset(_ keyPath: KeyPath<Item, TimeLine>, before timestamp: Date) {
            objectWillChange.send()
            self[keyPath: keyPath].reset(before: timestamp)
        }

        func reset(_ key: Key, before timestamp: Date) {
            guard let value = values[key] else { return }
            objectWillChange.send()
            value.reset(before: timestamp)
        }

        func merge(other: Item) {
            guard other.id == id else { return }

            objectWillChange.send()
            
            rolesValue = rolesValue.merged(with: other.rolesValue)
            deletedValue = deletedValue.merged(with: other.deletedValue)
            added = other.added

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
