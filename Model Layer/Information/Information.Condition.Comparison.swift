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
        case `nil`
        case below(Structure.Aspect.ID, Information.ValueStorage)
        case above(Structure.Aspect.ID, Information.ValueStorage)
        case equal(Structure.Aspect.ID, Information.ValueStorage)
        case unequal(Structure.Aspect.ID, Information.ValueStorage)

        // MARK: Internal

        func appendRole(role: Structure.Role, roles: inout [Structure.Role]) {
            guard roles.firstIndex(of: role) == nil else { return }
            roles.append(role)
        }

        func matches(for item: Information.Item, structure: Structure, roles: inout [Structure.Role]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .below(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return true }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue < value
            case let .above(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return false }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue > value
            case let .equal(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return false }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue == value
            case let .unequal(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return true }
                appendRole(role: aspect.role, roles: &roles)
                return itemValue != value
            }
        }

        func matches(for item: Information.Particle, structure: Structure, roles: inout [Structure.Role]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .below(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return true }
                return itemValue < value
            case let .above(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return false }
                return itemValue > value
            case let .equal(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return false }
                return itemValue == value
            case let .unequal(aspect, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item] else { return true }
                return itemValue != value
            }
        }
    }
}
