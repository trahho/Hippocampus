//
//  Information.Condition.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation

extension Information {
    indirect enum Condition: PersistentValue {
        case `nil`
        case always(Bool)
        case role(Structure.Role.ID)
        case hasParticle(Structure.Particle.ID, Condition)
        case isParticle(Structure.Particle.ID)
        case isReferenced(Condition)
        case isReferenceOfRole(Structure.Role.ID)
        case hasReference(Condition)
        case hasValue(Comparison)
        case not(Condition)
        case any([Condition])
        case all([Condition])

        // MARK: Internal

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

        typealias PersistentComparableValue = Comparable & PersistentValue

//        static func hasRole(_ role: Structure.Role) -> Self {
//            .hasRole(role.id)
//        }
//
//        var roles: Set<Structure.Role.ID> {
//            switch self {
//            case let .hasRole(role):
//                return [role]
//            case let .any(conditions), let .all(conditions):
//                return conditions.flatMap { $0.roles }.asSet
//            default:
//                return []
//            }
//        }

//        func matches(for item: Item, sameRole: Structure.Role? = nil, information: Information) -> Bool {
//            switch self {
//            case let .always(value):
//                return value
//            case let .hasRole(role):
//                if role == Structure.Role.same.id, let sameRole { return item.conforms(to: sameRole) }
//                guard let role = information[Structure.Role.self, role] else { return false }
//                return item.conforms(to: role)
//            case let .hasValue(comparison):
//                return comparison.matches(for: item, information: information)
//            case let .isReferenced(condition):
//                guard let item = item as? Item else { return false }
//                return item.from.contains(where: { condition.matches(for: $0, sameRole: sameRole, information: information) })
//            case let .hasReference(condition):
//                guard let item = item as? Item else { return false }
//                return item.to.contains(where: { condition.matches(for: $0, sameRole: sameRole, information: information) })
//            case let .not(condition):
//                return !condition.matches(for: item, sameRole: sameRole, information: information)
//            case let .any(conditions):
//                for condition in conditions {
//                    if condition.matches(for: item, sameRole: sameRole, information: information) {
//                        return true
//                    }
//                }
//                return false
//            case let .all(conditions):
//                for condition in conditions {
//                    if !condition.matches(for: item, sameRole: sameRole, information: information) {
//                        return false
//                    }
//                }
//                return true
//            }
//        }

        var roles: Set<Structure.Role.ID> {
            switch self {
            case let .role(role):
                return [role]
            case let .any(conditions), let .all(conditions):
                return conditions.flatMap { $0.roles }.asSet
            default:
                return []
            }
        }

        func appendRole(role: Structure.Role, roles: inout [Structure.Role]) {
            guard roles.firstIndex(of: role) == nil else { return }
            roles.append(role)
        }

        func matches(_ item: Information.Item, sameRole: Structure.Role? = nil, structure: Structure) -> Bool {
            var roles: [Structure.Role] = []
            return matches(item, sameRole: sameRole, structure: structure, roles: &roles)
        }

        func matches(_ item: Information.Item, sameRole: Structure.Role? = nil, structure: Structure, roles: inout [Structure.Role]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .always(truth):
                return truth
            case let .role(roleId):
                if roleId == Structure.Role.same.id, let sameRole, item.conforms(to: sameRole) != nil {
                    roles.append(sameRole)
                    return true
                }
                guard let role = structure[Structure.Role.self, roleId] else { return false }
                if item.conforms(to: role) != nil {
                    appendRole(role: role, roles: &roles)
                    return true
                }
                return false
            case let .isReferenceOfRole(roleId):
                guard let role = structure[Structure.Role.self, roleId] else { return false }
                return role.allReferences.map { reference in
                    Condition.role(reference.id).matches(item, sameRole: role, structure: structure, roles: &roles)
                }
                .reduce(false) { $0 || $1 }
//                let conditions: [Condition] = role.allReferences.map { .role($0.id) }
//                let result = conditions.reduce(false) { partialResult, condition in
//                    partialResult || condition.matches(item, sameRole: role, structure: structure, roles: &roles)
//                }
//                print("\(roleId) \(roles.count)")
//                return result
//                return condition.matches(item, sameRole: role, structure: structure, roles: &roles)
//                var matches = false
//                for reference in role.allReferences {
//                    let reference = if reference == Structure.Role.same { role } else { reference }
//                    if let role = item.conforms(to: reference) {
//                        appendRole(role: role, roles: &roles)
//                        matches = true
//                    }
//                }
//                return matches
            case .isParticle:
                return false
            case let .hasValue(comparison):
                return comparison.matches(for: item, structure: structure, roles: &roles)
            case let .isReferenced(condition):
                var blockRoles: [Structure.Role] = []
                return item.from.contains { condition.matches($0, sameRole: sameRole, structure: structure, roles: &blockRoles) }
            case let .hasReference(condition):
                var blockRoles: [Structure.Role] = []
                return item.to.contains { condition.matches($0, sameRole: sameRole, structure: structure, roles: &blockRoles) }
            case let .hasParticle(particleId, condition):
                return item.particles
                    .filter { $0.id == particleId }
                    .contains { condition.matches($0, structure: structure, roles: &roles) }
            case let .not(condition):
                var blockRoles: [Structure.Role] = []
                return !condition.matches(item, sameRole: sameRole, structure: structure, roles: &blockRoles)
            case let .any(conditions):
                return conditions.first { $0.matches(item, sameRole: sameRole, structure: structure, roles: &roles) } != nil
            case let .all(conditions):
                return conditions.first { !$0.matches(item, sameRole: sameRole, structure: structure, roles: &roles) } == nil
            }
        }

        func matches(_ item: Information.Particle, sameRole: Structure.Role? = nil, structure: Structure) -> Bool {
            var roles: [Structure.Role] = []
            return matches(item, structure: structure, roles: &roles)
        }

        func matches(_ item: Information.Particle, structure: Structure, roles: inout [Structure.Role]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .always(truth):
                return truth
            case .role:
                return false
            case let .isParticle(particleId):
                return item.particle == particleId
            case let .hasValue(comparison):
                return comparison.matches(for: item, structure: structure, roles: &roles)
            case .isReferenced, .hasReference, .hasParticle:
                return false
            case let .not(condition):
                return !condition.matches(item, structure: structure, roles: &roles)
            case let .any(conditions):
                return conditions.first { $0.matches(item, structure: structure, roles: &roles) } != nil
            case let .all(conditions):
                return conditions.first { !$0.matches(item, structure: structure, roles: &roles) } == nil
            case .isReferenceOfRole:
                return false
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
