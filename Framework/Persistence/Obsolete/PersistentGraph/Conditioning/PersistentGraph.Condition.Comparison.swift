//
//  PersistentGraph.Condition.Comparison.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation
import Smaug

extension PersistentGraph.Condition {
    struct Comparison: Serializable, Equatable {
        typealias Key = String

        enum Relation: Int {
            case below, above, equal, unequal
        }

        static func == (lhs: Comparison, rhs: Comparison) -> Bool {
            lhs.key == rhs.key && lhs.condition == rhs.condition && isEqual(lhs.value, rhs.value)
        }

        @Serialized var key: Key
        @Serialized var storage: PersistentGraph.ValueStorage?
        @Serialized var condition: Relation

        var value: (any PersistentComparableValue)? {
            get {
                storage?.value as? (any PersistentComparableValue)
            }
            set {
                storage = PersistentGraph.ValueStorage(newValue)
            }
        }

        init() {}

        init(key: Key, value: any PersistentComparableValue, condition: Relation) {
            self.key = key
            self.value = value
            self.condition = condition
        }

        func calculate(for item: PersistentGraph.Item) -> Bool {
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
