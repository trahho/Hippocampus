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
    }
}
