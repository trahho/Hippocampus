//
//  PersistentGraph.ValueStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.01.23.
//

import Foundation

extension PersistentGraph {
    indirect enum ValueStorage: TimedValueStorage {
        case `nil`
        case int(Int)
        case bool(Bool)
        case string(String)
        case date(Date)
        case roles([Role])
        case aspectPresentation(Structure.Aspect.Presentation)
        
        
        init?(_ value: (any PersistentGraph.PersistentValue)?) {
            if value == nil { self = .nil }
            else if let int = value as? Int { self = .int(int) }
            else if let bool = value as? Bool { self = .bool(bool) }
            else if let string = value as? String { self = .string(string) }
            else if let date = value as? Date { self = .date(date) }
            else if let roles = value as? Set<Role> { self = .roles(roles.asArray) }
            else if let aspectPresentation = value as? Structure.Aspect.Presentation { self = .aspectPresentation(aspectPresentation) }
            else { return nil }
            //        else { fatalError("Storage for \(value?.typeName ?? "Hä?") not available") }
        }
        
        var value: (any PersistentGraph.PersistentValue)? {
            switch self {
            case .nil: return nil
            case let .int(value): return value
            case let .bool(value): return value
            case let .string(value): return value
            case let .date(value): return value
            case let .roles(value): return value.asSet
                
            case let .aspectPresentation(value): return value
            }
        }
    }
}
