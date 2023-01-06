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
        @Serialized private(set) var roles = TimeLine(Set<Role>())
        @Serialized private(set) var values: [Key: TimeLine] = [:]
        @Serialized internal var deleted = TimeLine()
        @Serialized var added = Date()
        
        var graph: PersistentGraph?
        
        var isDeleted: Bool {
            get {
                deleted[Bool.self, graph] ?? false
            }
            set {
                deleted[Bool.self, graph, .deleted(self, graph?.timestamp ?? Date.distantFuture)] = newValue
            }
        }
        
        func reset(_ keyPath: KeyPath<Item, TimeLine>, before timestamp: Date) {
            guard let graph, graph.changing else { return }
            objectWillChange.send()
            self[keyPath: keyPath].reset(before: timestamp)
        }
        
        func reset(_ key: Key, before timestamp: Date) {
            guard let graph, graph.changing, let value = values[key] else { return }
            objectWillChange.send()
            value.reset(before: timestamp)
        }
        
        func adopt() {}
        
        func merge(other: Item) {
            guard other.id == id else { return }
            
            objectWillChange.send()
            
            roles = roles.merged(with: other.roles)
            deleted = deleted.merged(with: other.deleted)
            
            Set(values.keys).intersection(Set(other.values.keys))
                .forEach { key in
                    values[key] = values[key]!.merged(with: other.values[key]!)
                }

            Set(other.values.keys).subtracting(Set(values.keys))
                .forEach { key in
                    values[key] = other.values[key]!
                }
        }
        
        public subscript(role role: Role) -> Bool {
            get {
                roles[Set<Role>.self, graph]?.contains(role) ?? false
            }
            set {
                if newValue == true, self[role: role] == false {
                    roles[Set<Role>.self, graph, .role(self, graph?.timestamp ?? Date.distantFuture)]!.insert(role)
                } else if newValue == false, self[role: role] == true {
                    roles[Set<Role>.self, graph, .role(self, graph?.timestamp ?? Date.distantFuture)]!.remove(role)
                }
            }
        }
        
        internal func timedValue(for key: Key) -> TimedValue? {
            guard let value = values[key] else { return nil }
            return value.timedValue(at: graph?.timestamp)
        }
        
        public subscript<T>(_ type: T.Type, _ key: Key) -> T? where T: PersistentValue {
            get {
                guard let value = values[key] else { return nil }
                return value[T.self, graph]
            }
            set {
                objectWillChange.send()
                if values[key] == nil {
                    values[key] = TimeLine()
                }
                values[key]![T.self, graph, .modified(self, key, graph?.timestamp ?? Date.distantFuture)] = newValue
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
