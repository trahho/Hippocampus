//
//  Information.Modification.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.07.24.
//

import Foundation

extension Information {
    indirect enum Modification: PersistentValue {
        case setValue(Structure.Aspect.ID, ValueStorage)
        case setComputedValue(Structure.Aspect.ID, Computation)
        case conditioned(Condition, if: Modification, else: Modification?)
        case sequence([Modification])

        // MARK: Functions

        func modify(_ item: Aspectable, structure: Structure) {
            switch self {
            case let .setValue(aspectID, value):
                item[aspectID] = Structure.Aspect.Value(value)
            case let .setComputedValue(aspectID, computation):
                item[aspectID] = computation.compute(for: item, structure: structure)
            case let .conditioned(condition, ifModification, elseModification):
                if condition.matches(item, structure: structure) {
                    ifModification.modify(item, structure: structure)
                } else {
                    elseModification?.modify(item, structure: structure)
                }
            case let .sequence(modifications):
                modifications.forEach { $0.modify(item, structure: structure) }
            }
        }
    }
}
