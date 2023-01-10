//
//  PersistentGraph.Member.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

// public protocol PersistentValueStorage: Serializable {
//    associatedtype Role: CodableIdentifiable
//    associatedtype Key: CodableIdentifiable
//
//    var timestamp: Date? { get }
//    func getValue(at timestamp: Date?) -> PersistentGraph.PersistentValue?
//    func setValue(_ value: PersistentGraph.PersistentValue?, in graph: PersistentGraph?)
//    func reset(before timestamp: Date)
// }

extension PersistentGraph {
    open class Item: PersistentObject, ObservableObject {
        @Serialized private(set) var rolesValue = TimeLine(Set<Role>())
        @Serialized private(set) var values: [Key: TimeLine] = [:]
        @Serialized internal var deletedValue = TimeLine()
        @Serialized var added = Date()
        
        var graph: PersistentGraph!
        
        func reset(_ keyPath: KeyPath<Item, TimeLine>, before timestamp: Date) {
            objectWillChange.send()
            self[keyPath: keyPath].reset(before: timestamp)
        }
        
        func reset(_ key: Key, before timestamp: Date) {
            guard let value = values[key] else { fatalError("Reset for nonexisting value") }
            objectWillChange.send()
            value.reset(before: timestamp)
        }
        
        func adopt(changeManager: ChangeManager) {}
        
        func merge(other: Item) {
            guard other.id == id else { return }
            
            objectWillChange.send()
            
            rolesValue = rolesValue.merged(with: other.rolesValue)
            deletedValue = deletedValue.merged(with: other.deletedValue)
            
            Set(values.keys).intersection(Set(other.values.keys))
                .forEach { key in
                    values[key] = values[key]!.merged(with: other.values[key]!)
                }

            Set(other.values.keys).subtracting(Set(values.keys))
                .forEach { key in
                    values[key] = other.values[key]!
                }
        }
        
        public var isDeleted: Bool { deletedValue[Bool.self, graph] ?? false }
        
        public func isDeleted(_ newValue: Bool, changeManager: ChangeManager?) {
            deletedValue[Bool.self, changeManager ?? graph.changeManager(), { .deleted(self, $0) }] = newValue
        }
        
        public subscript(role role: Role, changeManager: ChangeManager? = nil) -> Bool {
            get {
                rolesValue[Set<Role>.self, graph]?.contains(role) ?? false
            }
            set {
                var newRoles = rolesValue[Set<Role>.self, graph] ?? Set<Role>()
                if newValue == true, !newRoles.contains(role) {
                    newRoles.insert(role)
                    rolesValue[Set<Role>.self, changeManager ?? graph.changeManager(), { .role(self, $0) }] = newRoles
                } else if newValue == false, newRoles.contains(role) {
                    newRoles.remove(role)
                    rolesValue[Set<Role>.self, changeManager ?? graph.changeManager(), { .role(self, $0) }] = newRoles
                }
            }
        }
        
        internal func timedValue(for key: Key) -> TimedValue? {
            guard let value = values[key] else { return nil }
            return value.timedValue(at: graph?.timestamp)
        }
        
        public subscript<T>(_ type: T.Type, _ key: Key, changeManager: ChangeManager? = nil) -> T? where T: PersistentValue {
            get {
                guard let value = values[key] else { return nil }
                return value[T.self, graph]
            }
            set {
                objectWillChange.send()
                if values[key] == nil {
                    values[key] = TimeLine()
                }
                values[key]![T.self, changeManager ?? graph.changeManager(), { .modified(self, key, $0) }] = newValue
            }
        }
        
//        public subscript(_ type: T.Type, _ key: Key) -> T? where T: PersistentValue {
//            get {
//                values[key]?[T.self, graph]
//            }
//            set {
//                if values[key] == nil {
//                    values[key] = TimeLine()
//                }
//                values[key]![T.self, graph, .modified(self, key, graph?.timestamp)] = newValue
//            }
//        }
    }
}
