//
//  Structure.Filter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.05.24.
//

import Foundation

extension Structure {
    class Filter: Object {
        @Property var name: String = ""
        @Objects var filter: [Filter]
        @Relations(\Self.filter) var subFilter: [Filter]
        @Property var layouts: [Presentation.Layout] = []
        @Property var order: [Presentation.Order] = []
        @Property var condition: Information.Condition?
        @Object var role: Structure.Role?

        var allConditions: [Information.Condition] {
            var filters = filter.flatMap { $0.allConditions }
            if let condition {
                filters += [condition]
            }
            if let role {
                filters += [.hasRole(role.id)]
            }
            return filters
        }
    }
}
