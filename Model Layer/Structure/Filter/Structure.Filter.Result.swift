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
//        var perspective: Structure.Perspective
//        let perspectives: [Structure.Perspective]
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
//    func filter(items: [Information.Item], additionalCondition: Information.Condition? = nil, samePerspective _: Structure.Perspective? = nil) -> [ResultItem] {
//        let condition = if let additionalCondition { additionalCondition && self.condition } else { self.condition }
//
//        return items
//            .compactMap { item in
//                var perspectives: [Structure.Perspective] = []
//                return condition.matches(item, structure: structure, perspectives: &perspectives) ? ResultItem(item: item, perspective: perspectives.finalsFirst.first!, perspectives: perspectives) : nil
//            }
//    }
//
//    func filter(items: [ResultItem], additionalCondition: Information.Condition? = nil, samePerspective: Structure.Perspective? = nil) -> [ResultItem] {
//        filter(items: items.map { $0.item }, additionalCondition: additionalCondition, samePerspective: samePerspective)
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
            let condition = filter.condition && filter.perspectives.reduce(.nil) { partialResult, perspective in partialResult || .perspective(perspective.id) }
            withObservationTracking {
                for item in filter[Information.Item.self] {
                    var perspectives: [Structure.Perspective] = []
                    if condition.matches(item, structure: filter.structure, perspectives: &perspectives) {
                        if storage[item.id] == nil {
                            storage[item.id] = Item(result: self, item: item, perspective: perspectives.finalsFirst.first!, perspectives: perspectives)
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
