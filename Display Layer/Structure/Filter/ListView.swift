//
//  ListView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 06.07.24.
//

import Foundation
import Grisu
import SwiftUI

struct ListView: View {
    // MARK: Properties

    @Environment(\.information) var information
    @Environment(\.structure) var structure
    @Bindable var result: Structure.Filter.Result
    @State var expansions = Expansions(defaultExpansion: false)

    // MARK: Computed Properties

    var rootItems: [Structure.Filter.Result.Item] {
//        guard !filter.roles.isEmpty else { return [] }
//        let allRoles: Information.Condition = filter.roles.reduce(.nil) { partialResult, role in
//            partialResult || .role(role.id)
//        }
//        let rootCondition = allRoles
//        let items = filter.filter(items: information.items.asArray, additionalCondition: rootCondition)
        if let order = result.filter.order {
            return result.items.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: structure) })
        } else {
            return result.items
        }
    }

    // MARK: Content

    var body: some View {
        List(result.items) { item in
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
