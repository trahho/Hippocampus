//
//  PersistentGraph.Predicate.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.12.22.
//

import Foundation

infix operator ~>: AdditionPrecedence
infix operator <~: AdditionPrecedence

extension PersistentGraph {
    indirect enum Condition: PersistentValue {
        typealias PersistentComparableValue = PersistentValue & Comparable
        typealias Storage = PersistentGraph.ValueStorage

        struct Comparison: Serializable, Equatable {
            enum Relation: Int {
                case below, above, equal, unequal
            }

            static func == (lhs: Comparison, rhs: Comparison) -> Bool {
                lhs.key == rhs.key && lhs.condition == rhs.condition && isEqual(lhs.value, rhs.value)
            }

            @Serialized var key: Key
            @Serialized var storage: Storage
            @Serialized var condition: Relation

            var value: (any PersistentComparableValue)? {
                get {
                    return storage.value as? (any PersistentComparableValue)
                }
                set {
                    storage = Storage(newValue)
                }
            }

            init() {}

            init(key: Key, value: any PersistentComparableValue, condition: Relation) {
                self.key = key
                self.value = value
                self.condition = condition
            }

            func calculate(for item: Item) -> Bool {
                guard let value = item.currentValue(key: key) as? (any Comparable) else { return false }
                switch condition {
                case .below:
                    return isBelow(value, self.value)
                case .above:
                    return !isEqual(value, self.value) && !isBelow(value, self.value)
                case .equal:
                    return isEqual(value, self.value)
                case .unequal:
                    return !isEqual(value, self.value)
                }
            }
        }

        case always(Bool)
        case hasRole(Role)
        case hasValue(Comparison)
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
