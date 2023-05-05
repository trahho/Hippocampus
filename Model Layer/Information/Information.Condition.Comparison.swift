//
//  Information.Condition.Comparison.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation
import Smaug

extension Information.Condition {
    struct Comparison: Serializable, Equatable {
        enum Relation: Int {
            case below, above, equal, unequal
        }
        
        static func == (lhs: Comparison, rhs: Comparison) -> Bool {
            lhs.key == rhs.key && lhs.condition == rhs.condition && isEqual(lhs.value, rhs.value)
        }
        
        @Serialized var key: String
        @Serialized var storage: Information.ValueStorage?
        @Serialized var condition: Relation
        
        var value: (any PersistentComparableValue)? {
            get {
                storage?.value as? (any PersistentComparableValue)
            }
            set {
                storage = Information.ValueStorage(newValue)
            }
        }
        
        init() {}
        
        init(key: String, value: any PersistentComparableValue, condition: Relation) {
            self.key = key
            self.value = value
            self.condition = condition
        }
        
        func calculate(for item: Information.Item) -> Bool {
            guard let value = item.value(key: key) as? (any Comparable) else { return false }
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


