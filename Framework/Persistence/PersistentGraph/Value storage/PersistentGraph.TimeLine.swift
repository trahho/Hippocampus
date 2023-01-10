//
//  PersistentGraph.Member.TimeLine.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.12.22.
//

import Foundation

extension PersistentGraph {
    struct TimeLine: Serializable {
        @Serialized private var values: [TimedValue]
                
        var timestamp: Date? {
            values.last?.time
        }
        
        init() {
            values = []
        }
        
        init(_ startValue: any PersistentGraph.PersistentValue) {
            values = [TimedValue(time: Date.distantPast, value: startValue)]
        }
        
        init(_ values: [TimedValue]) {
            self.values = values
        }
        
        func merged(with other: TimeLine) -> TimeLine {
            let temp = (values + other.values).sorted { $0.time < $1.time }
            guard !temp.isEmpty else { return TimeLine() }
            
            var result: [TimedValue] = [temp.first!]
            temp.forEach { current in
                let last = result.last!
                if current.time > last.time, !isEqual(last.value, current.value) {
                    result.append(current)
                }
            }
            return TimeLine(result)
        }
        
        func timedValue(at timestamp: Date?) -> TimedValue? {
            guard let timestamp else {
                return values.last
            }
            guard let value = values.last(where: { $0.time <= timestamp }) else {
                return nil
            }
            return value
        }
        
        subscript<T>(_ type: T.Type, _ graph: PersistentGraph) -> T? where T: PersistentGraph.PersistentValue {
            guard let timestamp = graph.timestamp else {
                return values.last?[T.self]
            }
            return values.last(where: { $0.time <= timestamp })?[T.self]
        }

        subscript<T>(_ type: T.Type,  _ changeManager: ChangeManager, _ change: ChangeBuilder) -> T? where T: PersistentGraph.PersistentValue {
            get {
                return self[type, changeManager.graph]
            }
            set {
                guard !changeManager.isBlocked else { fatalError("Change blocked") }
                if let value = values.last?[T.self], value == newValue {
                    return
                }
                changeManager.action {
                    if let last = values.last, last.time == changeManager.timestamp {
                        values.removeLast()
                    }
                    let newTimedValue = TimedValue(time: changeManager.timestamp, value: newValue)
                    values.append(newTimedValue)
                    changeManager.addChange(change(newTimedValue))
                }
            }
        }
        
        func reset(before timestamp: Date) {
            values = values.filter { $0.time < timestamp }.sorted(by: { $0.time < $1.time })
        }
    }
}
