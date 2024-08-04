//
//  Structure.Filter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.05.24.
//

import Foundation
import Grisu

extension Structure {
    class Filter: Object, Pickable {
        // MARK: Static Properties

        static let empty = Filter()

        // MARK: Properties

        @Property var name: String = ""
        @Objects var superFilters: [Filter]
        @Relations(\Self.superFilters) var subFilters: [Filter]

        @Property var condition: Information.Condition = .nil

        @Objects var roles: [Structure.Role]

        @Property var representations: [Representation] = []
        @Property var layouts: [Presentation.Layout] = []
        @Property var orders: [Presentation.Order] = []
        @Transient var layout: Presentation.Layout?
        @Transient var orderIndex: Int?
        @Transient var selectedItem: Result.Item?

//        var selectedItemId: Information.Item.ID? {
//            get { selectedItem?.item.id }
//            set {
//                if let newValue {
//                    selectedItem = result.first(where: { $0.id == newValue })
//                } else {
//                    selectedItem = nil
//                }
//            }
//        }

        var _result: Result?

        // MARK: Computed Properties

        var order: Presentation.Order? {
            get {
                guard let orderIndex else {
                    return nil
                }
                return orders[orderIndex]
            }
            set {
                guard let newValue, let index = orders.firstIndex(of: newValue) else {
                    orderIndex = nil
                    return
                }
                orderIndex = index
            }
        }

        var description: String {
            name.localized(isStatic)
        }

        var allRoles: [Role] {
            (roles + superFilters.flatMap { $0.allRoles }).asSet.asArray
        }

        var allLayouts: [Presentation.Layout] {
            (layouts + superFilters.flatMap { $0.allLayouts }).asSet.asArray
        }

        var allOrders: [Presentation.Order] {
            (orders + superFilters.flatMap { $0.allOrders }).asSet.asArray
        }

        var result: Result {
            if let _result {
                return _result
            }
            _result = Result(filter: self)
            return _result!
        }

        // MARK: Functions

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
