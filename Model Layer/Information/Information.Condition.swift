//
//  Information.Condition.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation

extension Information {
    indirect enum Condition: PersistentValue {
//        static func == (lhs: Information.Condition, rhs: Information.Condition) -> Bool {
//            switch lhs {
//            case let .always(lhsValue):
//                guard let .always(rhsValue) = lhs
//            case let .hasRole(role):
//                guard let role = item[Structure.Role.self, role] else {return false}
//                return item.roles.contains { $0.conforms(to: role) }
//            case let .hasValue(comparison):
//                return comparison.calculate(for: item)
//            case let .isReferenced(condition):
//                return item.from.contains(where: { condition.matches(for: $0) })
//            case let .hasReference(condition):
//                return item.to.contains(where: { condition.matches(for: $0) })
//            case let .not(condition):
//                return !condition.matches(for: item)
//            case let .any(conditions):
//                for condition in conditions {
//                    if condition.matches(for: item) {
//                        return true
//                    }
//                }
//                return false
//            case let .all(conditions):
//                for condition in conditions {
//                    if !condition.matches(for: item) {
//                        return false
//                    }
//                }
//                return true
//            }
//        }
        
        typealias PersistentComparableValue = PersistentValue & Comparable

        case always(Bool) 
        case hasRole(Structure.Role.ID)
        case hasValue(Comparison)
        case isReferenced(Condition)
        case hasReference(Condition)
        case not(Condition)
        case any([Condition])
        case all([Condition])

        static func hasRole(_ role: Structure.Role) -> Self {
            .hasRole(role.id)
        }

        func matches(for item: Item) -> Bool {
            switch self {
            case let .always(value):
                return value
            case let .hasRole(role):
                guard let role = item[Structure.Role.self, role] else {return false}
                return item.roles.contains { $0.conforms(to: role) }
            case let .hasValue(comparison):
                return comparison.matches(for: item)
            case let .isReferenced(condition):
                return item.from.contains(where: { condition.matches(for: $0) })
            case let .hasReference(condition):
                return item.to.contains(where: { condition.matches(for: $0) })
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

extension Equatable {
    func isEqualTo(_ other: (any Equatable)?) -> Bool {
        if let other = other as? Self, other == self {
            return true
        } else {
            return false
        }
    }
}

func isEqual(_ a: (any Equatable)?, _ b: (any Equatable)?) -> Bool {
    if a == nil, b == nil { return true }
    else if let a, a.isEqualTo(b) { return true }
    else if let b, b.isEqualTo(a) { return true }
    else { return false }
}

extension Comparable {
    func isBelow(_ other: (any Equatable)?) -> Bool {
        if let other = other as? Self, self < other {
            return true
        } else {
            return false
        }
    }
}

func isBelow(_ a: (any Comparable)?, _ b: (any Comparable)?) -> Bool {
    if a == nil, b != nil { return true }
    if a != nil, b == nil { return false }
    else if let a, a.isBelow(b) { return true }
    else if let b, b.isBelow(a) || b.isEqualTo(a) { return false }
    else { return false }
}
