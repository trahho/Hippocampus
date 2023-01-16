//
//  Aspect.Comparator.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 14.11.22.
//

import Foundation

extension Aspect {
    struct Comparator<Element: AspectStorage>: SortComparator {
        func compare(_ lhs: Element, _ rhs: Element) -> ComparisonResult {
            switch aspect.representation {
            case .text:
                return compare(lhs[aspect] ?? "", rhs[aspect] ?? "")
            case .drawing:
                return .orderedSame
            case .date:
                return compare(lhs[aspect] ?? Date.distantPast, rhs[aspect] ?? Date.distantPast)
            }
        }

        func compare<T: Comparable>(_ lhs: T, _ rhs: T) -> ComparisonResult {
            if lhs < rhs {
                return order == .forward ? .orderedAscending : .orderedDescending
            } else if lhs > rhs {
                return order == .forward ? .orderedDescending : .orderedAscending
            } else {
                return .orderedSame
            }
        }

        var order: SortOrder

        let aspect: Aspect
    }
}
