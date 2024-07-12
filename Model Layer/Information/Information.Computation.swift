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

        // MARK: Internal

//        func getValues<T: Comparable>(aspect: Structure.Aspect.ID, condition: Condition, for items: Set<Item>) -> [T] {
//            items.filter { condition.matches($0) }.compactMap { $0[aspect]?.value as? T }
//        }

        func compute(for items: [Item], structure: Structure) -> ValueStorage? {
            switch self {
            case let .minimum(aspect, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return nil }
                return items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0] }.min()
            case let .maximum(aspect, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return nil }
                return items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0] }.max()
            case let .count(condition):
                return ValueStorage(items.filter { condition.matches($0, structure: structure) }.count)
            }
        }

        func compute(for item: Item, structure: Structure) -> ValueStorage? {
            compute(for: [item], structure: structure)
        }

        func compute(for items: [Particle], structure: Structure) -> ValueStorage? {
            switch self {
            case let .minimum(aspect, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return nil }
                return items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0] }.min()
            case let .maximum(aspect, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return nil }
                return items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0] }.max()
            case let .count(condition):
                return ValueStorage(items.filter { condition.matches($0, structure: structure) }.count)
            }
        }

        func compute(for item: Particle, structure: Structure) -> ValueStorage? {
            compute(for: [item], structure: structure)
        }
    }
}
