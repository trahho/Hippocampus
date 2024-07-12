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
        @Objects var superFilters: [Filter]
        @Relations(\Self.superFilters) var subFilters: [Filter]

        @Property var condition: Information.Condition = .nil

        @Objects var roles: [Structure.Role]

        @Property var layouts: [Presentation.Layout] = []
        @Property var orders: [Presentation.Order] = []
        @Transient var layout: Presentation.Layout?
        @Transient var order: Presentation.Order?

        var allRoles: [Role] {
            (roles + superFilters.flatMap { $0.allRoles }).asSet.asArray
        }

        var allLayouts: [Presentation.Layout] {
            (layouts + superFilters.flatMap { $0.allLayouts }).asSet.asArray
        }

        var allOrders: [Presentation.Order] {
            (orders + superFilters.flatMap { $0.allOrders }).asSet.asArray
        }

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
        subscript(item: Information.Item, role: Structure.Role? = nil) -> Presentation.Properties.Properties {
            guard let layout else { return Presentation.Properties.Properties() }
            let properties: Presentation.Properties = self[Presentation.Properties.self, "\(id.uuidString)-\(layout.description)"]
            return properties(item: item, role: role)
        }
    }
}
