//
//  Information.Condition.Comparison.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation
import Smaug

extension Information.Condition {
    enum Comparison: Information.PersistentValue, Hashable {
        typealias Value = Information.ValueStorage
        typealias ID = Structure.Aspect.ID
        
        case `nil`
        case below(ID, Value)
        case above(ID, Value)
        case equal(ID, Value)
        case unequal(ID, Value)
        case hasValue(ID)

        // MARK: Functions

        // MARK: Internal

        func appendRole(role: Structure.Role?, roles: inout [Structure.Role]) {
            guard let role, roles.firstIndex(of: role) == nil else { return }
            roles.append(role)
        }

        func matches(for item: Aspectable, structure: Structure, roles: inout [Structure.Role]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .below(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item]?.valueStorage else { return true }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue < value
            case let .above(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item]?.valueStorage else { return false }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue > value
            case let .equal(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item]?.valueStorage else { return false }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue == value
            case let .unequal(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item]?.valueStorage else { return true }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue != value
            case let .hasValue(aspect):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return false }
                appendRole(role: aspect.role, roles: &roles)
                if aspect.isComputed {
                    return aspect[item] != nil
                } else {
                    return item[aspect.id] != nil
                }
            }
        }
    }
}
