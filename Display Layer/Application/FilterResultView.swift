//
//  FilterResultView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.05.24.
//

import Foundation
import Grisu
import SwiftUI

struct FilterResultView: View {
//    @State var items: [Information.Item]
    @State var filter: Structure.Filter
    @State var order: Presentation.Order?
    @State var layout: Presentation.Layout?

    var orders: [Presentation.Order] { filter.order }
//    var condition: Information.Condition { .all([filter.roots]) }

//    var sequence: [Presentation.Sequence] {
//        if let order = order ?? orders.first {
//            return [.ordered(condition, order: [order])]
//        } else {
//            return [.unordered(condition)]
//        }
//    }

    var test: Structure.Filter {
        print("\(filter.name) Result")
        return filter
    }

    var body: some View {
        VStack(alignment: .leading) {
//            Text(test.name)
//            if let role = filter.role {
            ListView(filter: filter)
//                    .environment(role)
//            } else {
//                EmptyView()
//            }
        }
    }
}

struct ListRowView: View {
    @Environment(Information.self) var information
    @Environment(Structure.self) var structure
    @State var item: Information.Item
    @State var filter: Structure.Filter
    @Binding var expansions: Expansions

    var condition: Information.Condition? {
        filter.leafs ?? filter.roots
    }

    var children: [Information.Item] {
        guard let condition else { return [] }
        return item.to.filter { condition.matches($0, structure: structure) }
    }

    var body: some View {
        if children.isEmpty {
            AspectView(item: item, aspect: Structure.Role.named[dynamicMember: "name"], appearance: .normal, editable: false)
        } else {
            DisclosureGroup(key: item.id.uuidString, isExpanded: $expansions) {
                if expansions[item.id.uuidString] {
                    ForEach(children) { item in
                        ListRowView(item: item, filter: filter, expansions: $expansions)
                    }
                }
            } label: {
                AspectView(item: item, aspect: Structure.Role.named[dynamicMember: "name"], appearance: .normal, editable: false)
            }
        }
    }
}

struct ListView: View {
    @Environment(Information.self) var information
    @Environment(Structure.self) var structure
    @State var filter: Structure.Filter
    @State var expansions = Expansions()

    var rootItems: [Information.Item] {
        guard let roots = filter.roots else { return [] }
        return information.items
            .filter { $0.from.isEmpty }
            .filter { roots.matches($0, sameRole: filter.role, structure: structure) }
    }

    var body: some View {
        List {
            ForEach(rootItems) { item in
                ListRowView(item: item, filter: filter, expansions: $expansions)
            }
        }
    }
}
