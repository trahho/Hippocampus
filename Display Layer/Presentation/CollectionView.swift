//
//  CollectionView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI

struct CollectionView: View {
    @Environment(Structure.Role.self) var role: Structure.Role
    @Environment(Structure.self) var structure
    @State var items: [Information.Item]
    @State var condition: Information.Condition
    @State var order: Presentation.Order?
    @State var layout: Presentation.Layout
    @State var appearance: Presentation.Appearance

    func compare(lhs: Information.Item, rhs: Information.Item, order: Presentation.Order) -> Bool {
        switch order {
        case .sorted(let aspect, let ascending):
//            guard let aspect = structure[Structure.Aspect.self, aspect] else { return false }
            if ascending {
                return lhs[aspect] ?? .nil < rhs[aspect] ?? .nil
            } else {
                return lhs[aspect] ?? .nil > rhs[aspect] ?? .nil
            }
        case .multiSorted(let sorters):
            for sorter in sorters {
                if compare(lhs: lhs, rhs: rhs, order: sorter) { return true }
                if compare(lhs: rhs, rhs: lhs, order: sorter) { return false }
            }
            return false
        }
    }

    var content: [Information.Item] {
        let items = items.filter { condition.matches(for: $0, sameRole: role) }
        guard let order else { return items }
        return items.sorted(by: { compare(lhs: $0, rhs: $1, order: order) })
    }

    var body: some View {
        ForEach(content, id: \.self) { item in
            if item.conforms(to: role) {
                LayoutItemView(item: item, layout: layout, appearance: appearance)
            } else {
                Image(systemName: "eye.trianglebadge.exclamationmark")
            }
        }
    }
}
