//
//  Information.Condition.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import CoreTransferable
import Foundation

extension Information {
    indirect enum Condition: PersistentValue, Hashable, Transferable {
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

        // MARK: Nested Types

        // MARK: Internal

        typealias PersistentComparableValue = Comparable & PersistentValue

        // MARK: Static Computed Properties

        static var transferRepresentation: some TransferRepresentation {
            CodableRepresentation(for: Condition.self, contentType: .text)
        }

        // MARK: Functions

        func matches(_ item: Aspectable, sameRole: Structure.Role? = nil, structure: Structure) -> Bool {
            var roles: [Structure.Role] = []
            return matches(item, sameRole: sameRole, structure: structure, roles: &roles)
        }

        func matches(_ item: Aspectable, sameRole: Structure.Role? = nil, structure: Structure, roles: inout [Structure.Role]) -> Bool {
            if let item = item as? Item {
                return itemMatches(item, sameRole: sameRole, structure: structure, roles: &roles)
            } else if let particle = item as? Particle {
                return particleMatches(particle, structure: structure, roles: &roles)
            } else { return false }
        }

        func itemMatches(_ item: Information.Item, sameRole: Structure.Role? = nil, structure: Structure, roles: inout [Structure.Role]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .always(truth):
                return truth
            case let .role(roleId):
                if roleId == Structure.Role.same.id, let sameRole, item.matchingRole(for: sameRole) != nil {
                    roles.append(sameRole)
                    return true
                }
                guard let role = structure[Structure.Role.self, roleId] else { return false }
                if let role = item.matchingRole(for: role) {
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
                    .contains { condition == .nil ? true : condition.matches($0, structure: structure, roles: &roles) }
            case let .not(condition):
                var blockRoles: [Structure.Role] = []
                return !condition.matches(item, sameRole: sameRole, structure: structure, roles: &blockRoles)
            case let .any(conditions):
                return conditions.first { $0.matches(item, sameRole: sameRole, structure: structure, roles: &roles) } != nil
            case let .all(conditions):
                return conditions.first { !$0.matches(item, sameRole: sameRole, structure: structure, roles: &roles) } == nil
            }
        }

        func particleMatches(_ item: Information.Particle, structure: Structure, roles: inout [Structure.Role]) -> Bool {
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
            case .hasParticle, .hasReference, .isReferenced:
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

        fileprivate func appendRole(role: Structure.Role, roles: inout [Structure.Role]) {
            guard roles.firstIndex(of: role) == nil else { return }
            roles.append(role)
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
