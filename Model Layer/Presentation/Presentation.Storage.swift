//
//  Presentation.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.04.23.
//

import Foundation

extension Presentation {
    indirect enum Storage: TimedValueStorage {
        case v(ValueStorage)
        case condition(Information.Condition)
        case roles([Structure.Role.ID])

        init(_ value: (any PersistentValue)?) {
            if let basicValue = ValueStorage(value) { self = .v(basicValue) }
         
            else if let condition = value as? Information.Condition { self = .condition(condition) }
            else if let roles = value as? Set<Structure.Role.ID> { self = .roles(roles.asArray) }
         
            else { fatalError("Storage for \(value?.typeName ?? "Hä?") not available") }
        }

        var value: (any PersistentValue)? {
            switch self {
            case let .v(value): return value.value
            case let .condition(value): return value
            case let .roles(value): return value.asSet
            }
        }
    }
}
