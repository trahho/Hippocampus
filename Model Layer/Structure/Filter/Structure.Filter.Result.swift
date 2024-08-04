//
//  Item.swift
//  Hippocampus
//
//  Created by Guido Kühn on 01.08.24.
//

import Grisu
import SwiftUI

// extension Structure.Filter {
//    struct ResultItem: Identifiable, Equatable, Hashable {
//        // MARK: Properties
//
//        let item: Information.Item
//        var role: Structure.Role
//        let roles: [Structure.Role]
//
//        // MARK: Computed Properties
//
//        var id: Information.Item.ID { item.id }
//    }
//
//    var structure: Structure {
//        store as! Structure
//    }
//
//    func filter(items: [Information.Item], additionalCondition: Information.Condition? = nil, sameRole _: Structure.Role? = nil) -> [ResultItem] {
//        let condition = if let additionalCondition { additionalCondition && self.condition } else { self.condition }
//
//        return items
//            .compactMap { item in
//                var roles: [Structure.Role] = []
//                return condition.matches(item, structure: structure, roles: &roles) ? ResultItem(item: item, role: roles.finalsFirst.first!, roles: roles) : nil
//            }
//    }
//
//    func filter(items: [ResultItem], additionalCondition: Information.Condition? = nil, sameRole: Structure.Role? = nil) -> [ResultItem] {
//        filter(items: items.map { $0.item }, additionalCondition: additionalCondition, sameRole: sameRole)
//    }
// }

extension Structure.Filter {
    var structure: Structure {
        store as! Structure
    }

    @Observable class Result {
        // MARK: Properties

        let filter: Structure.Filter

        @ObservationIgnored var storage: [Information.Item.ID: Item] = [:]

        var items: [Item] = []

        // MARK: Computed Properties

        var sorted: [Item] {
            if let order = filter.order {
                return storage.values.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: filter.structure) })
            } else {
                return storage.values.sorted(by: { $0.item.id < $1.item.id })
            }
        }

        // MARK: Lifecycle

        init(filter: Structure.Filter) {
            self.filter = filter
            refresh()
        }

        // MARK: Functions

        func refresh() {
            let condition = filter.condition && filter.roles.reduce(.nil) { partialResult, role in partialResult || .role(role.id) }
            withObservationTracking {
                for item in filter[Information.Item.self] {
                    var roles: [Structure.Role] = []
                    if condition.matches(item, structure: filter.structure, roles: &roles) {
                        if storage[item.id] == nil {
                            storage[item.id] = Item(result: self, item: item, role: roles.finalsFirst.first!, roles: roles)
                        }
                    } else {
                        if storage[item.id] != nil {
                            storage.removeValue(forKey: item.id)
                        }
                    }
                }
                items = sorted
            } onChange: {
                let dispatchQueue = DispatchQueue.global(qos: .userInteractive)
                dispatchQueue.async {
                    self.refresh()
                }
            }
        }
    }
}
