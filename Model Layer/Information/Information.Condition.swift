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
        case perspective(Structure.Perspective.ID)
        case hasParticle(Structure.Particle.ID, Condition)
        case isParticle(Structure.Particle.ID)
        case isReferenced(Condition)
        case isReferenceOfPerspective(Structure.Perspective.ID)
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

        func matches(_ item: Aspectable, samePerspective: Structure.Perspective? = nil, structure: Structure) -> Bool {
            var perspectives: [Structure.Perspective] = []
            return matches(item, samePerspective: samePerspective, structure: structure, perspectives: &perspectives)
        }

        func matches(_ item: Aspectable, samePerspective: Structure.Perspective? = nil, structure: Structure, perspectives: inout [Structure.Perspective]) -> Bool {
            if let item = item as? Item {
                return itemMatches(item, samePerspective: samePerspective, structure: structure, perspectives: &perspectives)
            } else if let particle = item as? Particle {
                return particleMatches(particle, structure: structure, perspectives: &perspectives)
            } else { return false }
        }

        func itemMatches(_ item: Information.Item, samePerspective: Structure.Perspective? = nil, structure: Structure, perspectives: inout [Structure.Perspective]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .always(truth):
                return truth
            case let .perspective(perspectiveId):
                if perspectiveId == Structure.Perspective.Statics.same.id, let samePerspective, item.matchingPerspective(for: samePerspective) != nil {
                    perspectives.append(samePerspective)
                    return true
                }
                guard let perspective = structure[Structure.Perspective.self, perspectiveId] else { return false }
                if let perspective = item.matchingPerspective(for: perspective) {
                    appendPerspective(perspective: perspective, perspectives: &perspectives)
                    return true
                }
                return false
            case let .isReferenceOfPerspective(perspectiveId):
                guard let perspective = structure[Structure.Perspective.self, perspectiveId] else { return false }
                return perspective.allReferences.map { reference in
                    Condition.perspective(reference.id).matches(item, samePerspective: perspective, structure: structure, perspectives: &perspectives)
                }
                .reduce(false) { $0 || $1 }
            case .isParticle:
                return false
            case let .hasValue(comparison):
                return comparison.matches(for: item, structure: structure, perspectives: &perspectives)
            case let .isReferenced(condition):
                var blockPerspectives: [Structure.Perspective] = []
                return item.from.contains { condition.matches($0, samePerspective: samePerspective, structure: structure, perspectives: &blockPerspectives) }
            case let .hasReference(condition):
                var blockPerspectives: [Structure.Perspective] = []
                return item.to.contains { condition.matches($0, samePerspective: samePerspective, structure: structure, perspectives: &blockPerspectives) }
            case let .hasParticle(particleId, condition):
                return item.particles
                    .filter { $0.id == particleId }
                    .contains { condition == .nil ? true : condition.matches($0, structure: structure, perspectives: &perspectives) }
            case let .not(condition):
                var blockPerspectives: [Structure.Perspective] = []
                return !condition.matches(item, samePerspective: samePerspective, structure: structure, perspectives: &blockPerspectives)
            case let .any(conditions):
                return conditions.first { $0.matches(item, samePerspective: samePerspective, structure: structure, perspectives: &perspectives) } != nil
            case let .all(conditions):
                return conditions.first { !$0.matches(item, samePerspective: samePerspective, structure: structure, perspectives: &perspectives) } == nil
            }
        }

        func particleMatches(_ item: Information.Particle, structure: Structure, perspectives: inout [Structure.Perspective]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .always(truth):
                return truth
            case .perspective:
                return false
            case let .isParticle(particleId):
                return item.particle == particleId
            case let .hasValue(comparison):
                return comparison.matches(for: item, structure: structure, perspectives: &perspectives)
            case .hasParticle, .hasReference, .isReferenced:
                return false
            case let .not(condition):
                return !condition.matches(item, structure: structure, perspectives: &perspectives)
            case let .any(conditions):
                return conditions.first { $0.matches(item, structure: structure, perspectives: &perspectives) } != nil
            case let .all(conditions):
                return conditions.first { !$0.matches(item, structure: structure, perspectives: &perspectives) } == nil
            case .isReferenceOfPerspective:
                return false
            }
        }

        fileprivate func appendPerspective(perspective: Structure.Perspective, perspectives: inout [Structure.Perspective]) {
            guard perspectives.firstIndex(of: perspective) == nil else { return }
            perspectives.append(perspective)
        }
    }
}
