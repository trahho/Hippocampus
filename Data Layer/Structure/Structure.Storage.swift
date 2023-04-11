//
//  Structure.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.04.23.
//

import Foundation
extension Structure {
    indirect enum Storage: ValueStorage {
        case `nil`
        case int(Int)
        case bool(Bool)
        case string(String)
        case date(Date)
        case roles([Role])
//        case predicates([Structure.Query.Predicate])
        case aspectPresentation(Structure.Aspect.Presentation)
//        case queryPredicate(Structure.Query.Predicate)
//        case roleRepresentation(Structure.Role.Representation)
        case roleRepresentations([Structure.Role.Representation])
//        case roleRepresentationMap([Structure.Role.ID: String])

        init(_ value: (any PersistentValue)?) {
            if value == nil { self = .nil }
            else if let int = value as? Int { self = .int(int) }
            else if let bool = value as? Bool { self = .bool(bool) }
            else if let string = value as? String { self = .string(string) }
            else if let date = value as? Date { self = .date(date) }
            else if let roles = value as? Set<Role> { self = .roles(roles.asArray) }
//            else if let predicates = value as? [Structure.Query.Predicate] { self = .predicates(predicates) }
            else if let aspectPresentation = value as? Structure.Aspect.Presentation { self = .aspectPresentation(aspectPresentation) }
//            else if let predicate = value as? Structure.Query.Predicate { self = .queryPredicate(predicate) }
//            else if let representation = value as? Structure.Role.Representation { self = .roleRepresentation(representation) }
            else if let representations = value as? [Structure.Role.Representation] { self = .roleRepresentations(representations) }
//            else if let representationMap = value as? [Structure.Role.ID: String] { self = .roleRepresentationMap(representationMap) }

            else { fatalError("Storage for \(value?.typeName ?? "Hä?") not available") }
        }

        var value: (any PersistentValue)? {
            switch self {
            case .nil: return nil
            case let .int(value): return value
            case let .bool(value): return value
            case let .string(value): return value
            case let .date(value): return value
            case let .roles(value): return value.asSet
//            case let .predicates(value):
//                return value
            case let .aspectPresentation(value): return value
//            case let .queryPredicate(value):
//                return value
//            case let .roleRepresentation(value):
//                return value
            case let .roleRepresentations(value):
                return value
//            case let .roleRepresentationMap(value):
//                return value
            }
        }
    }
}
