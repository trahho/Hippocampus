//
//  PersistentGraph.ValueStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.01.23.
//

import Foundation

extension PersistentGraph {
    indirect enum ValueStorage: PersistentGraph.PersistentValue {
        case `nil`
        case int(Int)
        case bool(Bool)
        case string(String)
        case date(Date)
        case roles([Role])
        case predicates([Structure.Query.Predicate])
        //        case array([ValueStorage])
        case aspectRepresentation(Structure.Aspect.Representation)
        case queryPredicate(Structure.Query.Predicate)

        init(_ value: (any PersistentGraph.PersistentValue)?) {
            if value == nil { self = .nil }
            else if let int = value as? Int { self = .int(int) }
            else if let bool = value as? Bool { self = .bool(bool) }
            else if let string = value as? String { self = .string(string) }
            else if let date = value as? Date { self = .date(date) }
            //            else if let array = value as? [any PersistentGraph.PersistentValue] { self = .array(array.map { ValueStorage($0) }) }
            else if let roles = value as? Set<Role> { self = .roles(roles.asArray) }
            else if let predicates = value as? [Structure.Query.Predicate] { self = .predicates(predicates) }
            else if let aspectRepresentation = value as? Structure.Aspect.Representation { self = .aspectRepresentation(aspectRepresentation) }
            else if let predicate = value as? Structure.Query.Predicate { self = .queryPredicate(predicate) }
            else { fatalError("Storage for \(value?.typeName ?? "Hä?") not available") }
        }

        var value: (any PersistentGraph.PersistentValue)? {
            switch self {
            case .nil:
                return nil
            case let .int(v):
                return v
            case let .bool(v):
                return v
            case let .string(v):
                return v
            case let .date(v):
                return v
            //            case let .array(v):
            //                var result =  [any PersistentGraph.PersistentValue]()
            ////                for storage in v {
            ////                    result.append(storage.value)
            ////                }
            //                return result
            case let .roles(v):
                return v.asSet
            case let .predicates(v):
                return v
            case let .aspectRepresentation(v):
                return v
            case let .queryPredicate(v):
                return v
            }
        }
    }
}
