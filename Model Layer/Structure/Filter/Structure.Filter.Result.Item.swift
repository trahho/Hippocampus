//
//  Item.swift
//  Hippocampus
//
//  Created by Guido Kühn on 01.08.24.
//

import Grisu
import SwiftUI

extension Structure.Filter.Result {
    struct Item: Identifiable, Equatable, Hashable {
        // MARK: Properties

        let result: Structure.Filter.Result
        let item: Information.Item
        var perspective: Structure.Perspective
        let perspectives: [Structure.Perspective]

        // MARK: Computed Properties

        var filter: Structure.Filter { result.filter }

        var id: Information.Item.ID { item.id }

        var children: [Item]? {
            let result = item.to
                .compactMap { self.result.storage[$0.id] }

            guard !result.isEmpty else { return nil }
            if let order = filter.order {
                return result.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: filter.structure) })
            } else {
                return result
            }
        }

        var parents: [Item]? {
            let result = item.from
                .compactMap { self.result.storage[$0.id] }

            guard !result.isEmpty else { return nil }
            if let order = filter.order {
                return result.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: filter.structure) })
            } else {
                return result
            }
        }

        var isSelected: Bool {
            get { result.filter.selectedItem == self }
            nonmutating set {
                if result.filter.selectedItem == self, newValue == false {
                    result.filter.selectedItem = nil
                } else if result.filter.selectedItem != self, newValue == true {
                    result.filter.selectedItem = self
                }
            }
        }

        // MARK: Static Functions

        static func == (lhs: Structure.Filter.Result.Item, rhs: Structure.Filter.Result.Item) -> Bool {
            lhs.id == rhs.id
        }

        // MARK: Functions

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
