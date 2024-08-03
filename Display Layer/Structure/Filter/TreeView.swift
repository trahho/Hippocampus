//
//  TreeView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 06.07.24.
//

import Foundation
import Grisu
import SwiftUI

struct TreeView: View {
    // MARK: Properties

    @Environment(\.information) var information
    @Environment(\.structure) var structure
    @Bindable var result: Structure.Filter.Result
    @State var expansions = Expansions(defaultExpansion: false)

    // MARK: Computed Properties

    var rootItems: [Structure.Filter.Result.Item] {
//        var notReferenced: Information.Condition = .nil
//        return filter.roles.referencingFirst.flatMap { role in
//            let rootCondition: Information.Condition = .role(role.id)
//            notReferenced = notReferenced && !.role(role.id)<~ // .not(.isReferenced(.hasRole(filter.role.id)))
        ////            notReferenced = !.role(role.id)<~
//            let fullCondition = rootCondition && notReferenced
//            let items = filter.filter(items: information.items.asArray, additionalCondition: fullCondition)
//                //            .filter { notReferenced.matches($0, structure: structure) }
//                .compactMap {
//                    fullCondition.matches($0, structure: structure)
//                }
        let items = result.items.filter { $0.parents == nil }
        if let order = result.filter.order {
            return items.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: structure) })
        } else {
            return items
        }
    }

    // MARK: Content

    var body: some View {
//        List {
//            ForEach(rootItems, id: \.item) { item in
//                RowView(item: item, filter: filter, expansions: $expansions)
//            }
        ////            .listRowBackground(Color.blue)
//            .listRowSeparator(.hidden)
//        }
        List(result.items, children: \.children) { item in
            FilterResultView.ItemView(item: item, layout: .list)
                .padding(2)
                .contentShape(Rectangle())
                .onTapGesture {
                    item.isSelected = true
                }
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.accentColor, lineWidth: 2).hidden(!item.isSelected))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
    }
}
