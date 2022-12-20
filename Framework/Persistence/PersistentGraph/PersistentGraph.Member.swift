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
    open class Member: PersistentObject, ObservableObject {
        @Serialized private(set) var roles = TimeLine()
        @Serialized private(set) var values: [Key: TimeLine] = [:]
        @Serialized internal var deleted = TimeLine()
        @Serialized internal var added = Date()
        
        var graph: PersistentGraph?
        
        var isDeleted: Bool {
            get {
                deleted.getValue(at: graph?.timestamp) as? Bool ?? false
            }
            set {
                if let graph {
                    graph.change {
                        guard isDeleted != newValue, let timestamp = graph.timestamp else { return }
                        deleted.setValue(newValue, in: graph)
                        graph.addChange(.deleted(self, timestamp))
                    }
                } else {
                    let timeline = TimeLine()
                    timeline.setValue(newValue)
                    deleted = timeline
                }
            }
        }
        
        func reset(_ keyPath: KeyPath<Member, TimeLine>, before timestamp: Date) {
            guard let graph, graph.changing else { return }
            objectWillChange.send()
            self[keyPath: keyPath].reset(before: timestamp)
        }
                
        func reset(_ key: Key, before timestamp: Date) {
            guard let graph, graph.changing, let value = values[key] else { return }
            objectWillChange.send()
            value.reset(before: timestamp)
        }
        
        public subscript(role role: Role) -> Bool {
            get {
                guard let roles = roles.getValue(at: graph?.timestamp) as? Set<Role> else { return false }
                return roles.contains(role)
            }
            set {
                objectWillChange.send()
               
                if let graph {
                    graph.change {
                        guard let timestamp = graph.timestamp else { return }
                        var value = roles.getValue(at: graph.timestamp) as? Set<Role> ?? []
                        if newValue {
                            value.insert(role)
                        } else {
                            value.remove(role)
                        }
                        roles.setValue(value, in: graph)
                        graph.addChange(.role(self, timestamp))
                    }
                } else {
                    var value = roles.getValue(at: graph?.timestamp) as? Set<Role> ?? []
                    if newValue {
                        value.insert(role)
                    } else {
                        value.remove(role)
                    }
                    let timeline = TimeLine()
                    timeline.setValue(value)
                    roles = timeline
                }
            }
        }
        
        public subscript(_ key: Key) -> PersistentValue? {
            get {
                return values[key]?.getValue(at: Date())
            }
            set {
                objectWillChange.send()
                if values[key] == nil {
                    values[key] = TimeLine()
                }
                if let graph {
                    graph.change {
                        guard let value = values[key], let timestamp = graph.timestamp else { return }
                        value.setValue(newValue, in: graph)
                        graph.addChange(.modified(self, key, timestamp))
                    }
                } else {
                    let timeline = TimeLine()
                    timeline.setValue(newValue)
                    values[key] = timeline
                }
            }
        }
    }
}
