//
//  PersistentGraph.Member.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

extension PersistentGraph {
    open class Member: PersistentObject, ObservableObject {
        struct TimedValue: Serializable {
            @Serialized private(set) var time: Date
            @Serialized private(set) var value: PersistentValue
            
            init() {}
            
            init(time: Date, value: PersistentValue) {
                self.time = time
                self.value = value
            }
        }
        
        @Serialized private(set) var roles: Set<Role> = []
        @Serialized private(set) var values: [Key: [TimedValue]] = [:]
        
        var graph: PersistentGraph<Role, Key>?
        
        //    required public init() {}
        
        func rewind(_ key: Key, to timestamp: Date) {
            guard let graph, graph.changing, let value = values[key] else { return }
            objectWillChange.send()
            values[key] = value.filter { $0.time < timestamp }
        }
        
        public subscript(role role: Role) -> Bool {
            get {
                roles.contains(role)
            }
            set {
                objectWillChange.send()
                roles.insert(role)
            }
        }
        
        public subscript(_ key: Key) -> PersistentValue {
            get {
                let result = values[key]?.last(where: { $0.time <= graph?.timestamp ?? Date() })
                return result?.value
            }
            set {
                objectWillChange.send()
                guard let graph else {
                    values[key] = [TimedValue(time: Date(), value: newValue)]
                    return
                }
                graph.change {
                    guard let timestamp = graph.timestamp else { return }
                    
                    if let timeline = values[key], let last = timeline.last {
                        if last.time <= timestamp {
                            if last.time == timestamp {
                                values[key]!.removeLast()
                            }
                            values[key]!.append(TimedValue(time: timestamp, value: newValue))
                        }
                    } else {
                        values[key] = [TimedValue(time: timestamp, value: newValue)]
                    }
                    
                    graph.addChange(.modified(self, key, timestamp))
                }
            }
        }
    }
}
