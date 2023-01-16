//
//  Aspect+Comparisons.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.09.22.
//

import Foundation

extension Aspect {
    func below(_ value: String) -> Mind.Opinion.AspectValueComparison {
        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .below, value: .string(value))
    }

    func below(_ value: Date) -> Mind.Opinion.AspectValueComparison {
        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .below, value: .date(value))
    }

    func below(_ value: Int) -> Mind.Opinion.AspectValueComparison {
        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .below, value: .int(value))
    }

    func above(_ value: String) -> Mind.Opinion.AspectValueComparison {
        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .above, value: .string(value))
    }

    func above(_ value: Date) -> Mind.Opinion.AspectValueComparison {
        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .above, value: .date(value))
    }

    func above(_ value: Int) -> Mind.Opinion.AspectValueComparison {
        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .above, value: .int(value))
    }

//    func isEqual<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
//        Mind.Opinion.AspectValueComparison<T>(aspect: self, comparison: .equal, value: value)
//    }
//
//    func isUnequal<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
//        Mind.Opinion.AspectValueComparison<T>(aspect: self, comparison: .unequal, value: value)
//    }
}

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        !lhs && rhs
    }
}
