//
//  PersistentGraph.Member.TimeLine.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.12.22.
//

import Foundation

extension PersistentGraph.Item {
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
            guard let timestamp  else {
                return values.last
            }
            guard let value = values.last(where: { $0.time <= timestamp }) else {
                return nil
            }
            return value
        }
        
        subscript<T>(_ type: T.Type, _ graph: PersistentGraph? = nil) -> T? where T: PersistentGraph.PersistentValue {
            guard let timestamp = graph?.timestamp else {
                if let value = values.last {
                    return value[T.self] 
                }
               return nil
            }
            guard let value = values.last(where: { $0.time <= timestamp }) else {
                return nil
            }
            return value.value as? T
        }

        subscript<T>(_ type: T.Type, _ graph: PersistentGraph? = nil, _ change: @autoclosure (() -> PersistentGraph.Change)) -> T? where T: PersistentGraph.PersistentValue {
            get {
                return self[type, graph]
            }
            set {
                if let value = values.last?.value as? T, value == newValue {
                    return
                }
                guard let graph = graph else {
                    values = [TimedValue(time: Date(), value: newValue)]
                    return
                }
//                guard let timestamp = graph.timestamp else {
//                    return
//                }
                graph.change {
                    guard let timestamp = graph.timestamp else { return }
                    print("Changing value")
                    if let last = values.last, last.time == timestamp {
                        values.removeLast()
                    }
                    values.append(TimedValue(time: timestamp, value: newValue))
                    graph.addChange(change())
                }
            }
        }
        
        func reset(before timestamp: Date) {
            values = values.filter { $0.time < timestamp }.sorted(by: { $0.time < $1.time })
        }
    }
}
