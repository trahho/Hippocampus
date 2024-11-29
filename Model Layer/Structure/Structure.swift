//
//  Structure.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

class Structure: ObjectStore {
    // MARK: Properties

    @Objects var perspectives: Set<Perspective>
    @Objects var particles: Set<Particle>
    @Objects var aspects: Set<Aspect>
    @Objects var filters: Set<Filter>
    @Transient var selectedFilter: Filter?

    // MARK: Computed Properties

    var selectedFilterId: Structure.Filter.ID? {
        get { selectedFilter?.id }
        set {
            if let newValue {
                selectedFilter = self[Filter.self, newValue]
            } else {
                selectedFilter = nil
            }
        }
    }
}
