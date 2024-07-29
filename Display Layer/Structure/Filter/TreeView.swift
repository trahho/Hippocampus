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
    // MARK: Nested Types

    typealias Result = (item: Information.Item, role: Structure.Role, roles: [Structure.Role])

    // MARK: Properties

    @Environment(\.information) var information
    @Environment(\.structure) var structure
    @State var filter: Structure.Filter
    @Binding var selectedItem: Information.Item?
    @State var expansions = Expansions(defaultExpansion: false)

    // MARK: Computed Properties

    var rootItems: [Result] {
        var notReferenced: Information.Condition = .nil
        return filter.roles.referencingFirst.flatMap { role in
            let rootCondition = filter.condition && .role(role.id)
            notReferenced = notReferenced && !.role(role.id)<~ // .not(.isReferenced(.hasRole(filter.role.id)))
//            notReferenced = !.role(role.id)<~
            let fullCondition = rootCondition && notReferenced
            let items = information.items
                //            .filter { notReferenced.matches($0, structure: structure) }
                .compactMap {
                    var roles: [Structure.Role] = []
                    return fullCondition.matches($0, structure: structure, roles: &roles) ? Result(item: $0, roles.finalsFirst.first!, roles: roles) : nil
                }
            if let order = filter.order {
                return items.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: structure) })
            } else {
                return items
            }
        }
    }

    // MARK: Content

    var body: some View {
        List {
            ForEach(rootItems, id: \.item) { item in
                RowView(item: item.item, selectedItem: $selectedItem, role: item.role, roles: item.roles, filter: filter, expansions: $expansions)
            }
//            .listRowBackground(Color.blue)
            .listRowSeparator(.hidden)
        }
    }
}


