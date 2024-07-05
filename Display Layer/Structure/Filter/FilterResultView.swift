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
    @State var level: Int = 0
    
    var condition: Information.Condition? {
        filter.leafs ?? filter.roots
    }

    var key: String {
        item.id.uuidString + String(level)
    }

    var children: [Information.Item] {
//        print("children: \(item.id.uuidString) expanded: \(expansions[item.id.uuidString])")
//        let fullcondition: Information.Condition = if let leafs = filter.leafs { .all([.isReferenceOfRole(filter.role.id), leafs]) } else { .isReferenceOfRole(filter.role.id) }
//        guard expansions[item.id.uuidString] else { return [] }
//        return item.to.filter { fullcondition.matches($0, structure: structure) }
        guard let role = filter.role else { return [] }
        return role.to.flatMap { reference in
            let reference = if reference == Structure.Role.same { role } else { reference }
            return item.to.filter { $0.conforms(to: reference) != nil }
                .sorted(by: { filter.order.first!.compare(lhs: $0, rhs: $1, structure: structure) })
        }
    }

    var body: some View {
        if children.isEmpty {
            AspectView(item: item, aspect: Structure.Role.named[dynamicMember: "name"], appearance: .normal, editable: false)
        } else {
            DisclosureGroup(key: key, isExpanded: $expansions) {
                if expansions[key] {
                    ForEach(children) { item in
                        ListRowView(item: item, filter: filter, expansions: $expansions, level: level + 1)
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
    @State var expansions = Expansions(defaultExpansion: false)

    var rootItems: [Information.Item] {
        let rootCondition: Information.Condition = if let roots = filter.roots { .all([.hasRole(filter.role.id), roots]) } else { .hasRole(filter.role.id) }
        let notReferenced: Information.Condition = .not(.isReferenced(.hasRole(filter.role.id)))
        let fullCondition: Information.Condition = .all([rootCondition, notReferenced])
        return information.items
//            .filter { notReferenced.matches($0, structure: structure) }
            .filter { fullCondition.matches($0, sameRole: filter.role, structure: structure) }
            .sorted(by: { filter.order.first!.compare(lhs: $0, rhs: $1, structure: structure) })
    }

    var body: some View {
        List {
            ForEach(rootItems) { item in
                ListRowView(item: item, filter: filter, expansions: $expansions)
            }
        }
    }
}
