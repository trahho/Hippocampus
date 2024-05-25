//
//  Information.Computation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.05.24.
//

import Foundation

extension Information {
    indirect enum Computation: PersistentValue {
        case minimum(Structure.Aspect.ID, Condition)
        case maximum(Structure.Aspect.ID, Condition)
        case count(Condition)

        func getValues<T: Comparable>(aspect: Structure.Aspect.ID, condition: Condition, for items: Set<Item>) -> [T] {
            items.filter { condition.matches(for: $0) }.compactMap { $0[aspect]?.value as? T }
        }

        func compute(for items: Set<Item>) -> ValueStorage? {
            switch self {
            case let .minimum(aspect, condition):
                items.filter { condition.matches(for: $0) }.compactMap { $0[aspect] }.min()
            case let .maximum(aspect, condition):
                items.filter { condition.matches(for: $0) }.compactMap { $0[aspect] }.max()
            case let .count(condition):
                ValueStorage(items.filter { condition.matches(for: $0) }.count)
                
            }
        }
    }
}
