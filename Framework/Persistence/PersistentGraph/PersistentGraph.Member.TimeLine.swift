//
//  PersistentGraph.Member.TimeLine.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.12.22.
//

import Foundation

extension PersistentGraph.Member {
    struct TimeLine {
        @Serialized private var values: [TimedValue] = []
        
        var timestamp: Date? {
            values.last?.time
        }
        
        func getValue(at timestamp: Date?) -> PersistentGraph.PersistentValue? {
            let timestamp = timestamp ?? Date()
            guard let value = values.last(where: { $0.time <= timestamp }) else { return nil }
            return value.value
        }
        
        func setValue(_ value: PersistentGraph.PersistentValue?, in graph: PersistentGraph? = nil) {
            guard let graph = graph else {
                values = [TimedValue(time: Date(), value: value)]
                return
            }
            graph.change {
                guard let timestamp = graph.timestamp else { return }
                
                if let last = values.last {
                    if last.time <= timestamp {
                        if last.time == timestamp {
                            values.removeLast()
                        }
                        values.append(TimedValue(time: timestamp, value: value))
                    }
                } else {
                    values = [TimedValue(time: timestamp, value: value)]
                }
            }
        }
        
        func reset(before timestamp: Date) {
            values = values.filter { $0.time < timestamp }
        }
    }
}
