//
//  Information.Computation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.05.24.
//

import Foundation

extension Information {
    indirect enum Computation: PersistentValue {
        case count(Condition)
        case minimum(Structure.Aspect.ID, Condition)
        case maximum(Structure.Aspect.ID, Condition)

        // MARK: Nested Types

        typealias Value = Structure.Aspect.Value

        // MARK: Functions

        // MARK: Internal

//        func getValues<T: Comparable>(aspect: Structure.Aspect.ID, condition: Condition, for items: Set<Item>) -> [T] {
//            items.filter { condition.matches($0) }.compactMap { $0[aspect]?.value as? T }
//        }

//        func matches(_ item: Aspectable, sameRole: Structure.Role? = nil, structure: Structure) -> Bool {
//            var roles: [Structure.Role] = []
//            return matches(item, sameRole: sameRole, structure: structure, roles: &roles)
//        }
//
//        func matches(_ item: Aspectable, sameRole: Structure.Role? = nil, structure: Structure, roles: inout [Structure.Role]) -> Bool {
//            if let item = item as? Item {
//                return itemMatches(item, sameRole: sameRole, structure: structure, roles: &roles)
//            } else if let particle = item as? Particle {
//                return particleMatches(particle, structure: structure, roles: &roles)
//            }
//        }

        func compute(for items: [Aspectable], structure: Structure) -> Value {
            switch self {
            case let .minimum(aspect, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return Value() }
                return Value(items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0].storage }.min())
            case let .maximum(aspect, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return Value() }
                return Value(items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0].storage }.max())
            case let .count(condition):
                return Value(ValueStorage(items.filter { condition.matches($0, structure: structure) }.count))
            }
        }

        func compute(for item: Aspectable, structure: Structure) -> Value {
            compute(for: [item], structure: structure)
        }
    }
}
