//
//  Aspect+Comparisons.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.09.22.
//

import Foundation

extension Aspect {
    func below<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
        Mind.Opinion.AspectValueComparison<T>(perspective: perspective.id, aspect: id, comparison: .below, value: value)
    }
    
    func above<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
        Mind.Opinion.AspectValueComparison<T>(perspective: perspective.id, aspect: id, comparison: .above, value: value)
    }
    
    func isEqual<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
        Mind.Opinion.AspectValueComparison<T>(perspective: perspective.id, aspect: id, comparison: .equal, value: value)
    }

    func isUnequal<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
        Mind.Opinion.AspectValueComparison<T>(perspective: perspective.id, aspect: id, comparison: .unequal, value: value)
    }
}

extension Bool : Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        !lhs && rhs 
    }
}
