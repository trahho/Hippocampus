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

        @Property var roots: Information.Condition? 
        @Property var leafs: Information.Condition?

        @Object var role: Structure.Role?
        @Property var layouts: [Presentation.Layout] = []
        @Property var order: [Presentation.Order] = []

//        private var getAspect: (Aspect.ID) -> Aspect? { { self[Aspect.self, $0] }}

//        var rootItems: [Information.Item] {
//            self[Information.Item.self].filter { roots.matches($0, getAspect: getAspect) }
//        }
//
//        var leafItems: [Information.Item] {
//            rootItems.flatMap { item in
//                item.allChildren.filter { leafs.matches($0, getAspect: getAspect) }
//            }
//            .asSet.asArray
//        }

//        var allConditions: [Information.Condition] {
//            var filters = filter.flatMap { $0.allConditions }
//            if let roots {
//                filters += [roots]
//            }
//            if let role {
//                filters += [.hasRole(role.id)]
//            }
//            return filters
//        }
    }
}
