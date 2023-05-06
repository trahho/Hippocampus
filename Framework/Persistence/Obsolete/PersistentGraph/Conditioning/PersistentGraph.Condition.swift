//
//  PersistentGraph.Predicate.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.12.22.
//

import Foundation

extension PersistentGraph {
    indirect enum Condition: PersistentValue {
        typealias PersistentComparableValue = PersistentValue & Comparable

        case always(Bool)
        case hasRole(Role)
        case hasValue(Comparison)
        case isReferenced(Condition)
        case hasReference(Condition)
        case not(Condition)
        case any([Condition])
        case all([Condition])

        func matches(for item: Item) -> Bool {
            switch self {
            case let .always(value):
                return value
            case let .hasRole(role):
                return item[role: role]
            case let .hasValue(comparison):
                return comparison.calculate(for: item)
            case let .isReferenced(condition):
                if let node = item as? Node {
                    return node.incoming.contains(where: { condition.matches(for: $0) })
                } else if let edge = item as? Edge {
                    return condition.matches(for: edge.from)
                } else {
                    return false
                }
            case let .hasReference(condition):
                if let node = item as? Node {
                    return node.outgoing.contains(where: { condition.matches(for: $0) })
                } else if let edge = item as? Edge {
                    return condition.matches(for: edge.to)
                } else {
                    return false
                }
            case let .not(condition):
                return !condition.matches(for: item)
            case let .any(conditions):
                for condition in conditions {
                    if condition.matches(for: item) {
                        return true
                    }
                }
                return false
            case let .all(conditions):
                for condition in conditions {
                    if !condition.matches(for: item) {
                        return false
                    }
                }
                return true
            }
        }
    }
}

