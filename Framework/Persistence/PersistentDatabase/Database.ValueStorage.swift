//
//  Database.ValueStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 01.05.23.
//

import Foundation

extension Database {
    indirect enum ValueStorage: TimedValueStorage {
        case a(Int)
        case b(Bool)
        case c(String)
        case d(Date)
//        case e([Role])
        case f([Object.ID])
        case g(UUID)

        init?(_ value: (any PersistentGraph.PersistentValue)?) {
            if value == nil { return nil }
            else if let value = value as? Int { self = .a(value) }
            else if let value = value as? Bool { self = .b(value) }
            else if let value = value as? String { self = .c(value) }
            else if let value = value as? Date { self = .d(value) }
//            else if let value = value as? Set<Role> { self = .e(value.asArray) }
            else if let value = value as? Set<Object.ID> { self = .f(value.asArray) }
            else if let uuid = value as? UUID { self = .g(uuid) }
            else { return nil }
            //        else { fatalError("Storage for \(value?.typeName ?? "Hä?") not available") }
        }

        var value: (any PersistentGraph.PersistentValue)? {
            switch self {
            case let .a(value): return value
            case let .b(value): return value
            case let .c(value): return value
            case let .d(value): return value
//            case let .e(value): return value.asSet
            case let .f(value): return value.asSet
            case let .g(value): return value
            }
        }
    }
}
