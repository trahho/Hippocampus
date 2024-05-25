//
//  Information.Condition.Comparison.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation
import Smaug

extension Information.Condition {
    enum Comparison: Information.PersistentValue {
        case below(Structure.Aspect.ID, ValueStorage)
        case above(Structure.Aspect.ID, ValueStorage)
        case equal(Structure.Aspect.ID, ValueStorage)
        case unequal(Structure.Aspect.ID, ValueStorage)

        func matches(for item: Information.Item) -> Bool {
            switch self {
            case let .below(aspect, value):
                guard let itemValue = item[aspect] else { return true }
                return itemValue < value
            case let .above(aspect, value):
                guard let itemValue = item[aspect] else { return false }
                return itemValue > value
            case let .equal(aspect, value):
                guard let itemValue = item[aspect] else { return false }
                return itemValue == value
            case let .unequal(aspect, value):
                guard let itemValue = item[aspect] else { return true }
                return itemValue != value
            }
        }
    }
}
