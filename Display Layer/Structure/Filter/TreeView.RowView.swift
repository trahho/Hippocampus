//
//  TreeView.RowView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import Grisu
import SwiftUI

extension TreeView {
    struct RowView: View {
        // MARK: Properties

        @Environment(\.information) var information
        @Environment(\.structure) var structure
        @State var item: Information.Item
        @Binding var selectedItem: Information.Item?
        @State var role: Structure.Role!
        @State var roles: [Structure.Role]
        @State var filter: Structure.Filter
        @Binding var expansions: Expansions
        @State var level: Int = 0

        // MARK: Computed Properties

//        var condition: Information.Condition? {
//            filter.leafs ?? filter.roots
//        }

        var key: String {
            item.id.uuidString + String(level)
        }

        var children: [Result] {
            let condition: Information.Condition = .isReferenceOfRole(role.id)

            //        print("children: \(item.id.uuidString) expanded: \(expansions[item.id.uuidString])")
            //        let fullcondition: Information.Condition = if let leafs = filter.leafs { .all([.isReferenceOfRole(filter.role.id), leafs]) } else { .isReferenceOfRole(filter.role.id) }
            //        guard expansions[item.id.uuidString] else { return [] }
            //        return item.to.filter { fullcondition.matches($0, structure: structure) }
//            filter.allRoles
//                .filter { $0.conforms(to: filter.roles) != nil }
            let items = item.to.compactMap {
                var roles: [Structure.Role] = []
                return condition.matches($0, structure: structure, roles: &roles) ? Result(item: $0, role: roles.referencingFirst.first!, roles: roles) : nil
            }
            if let order = filter.order {
                return items.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: structure) })
            } else {
                return items
            }
        }

        // MARK: Content

        var body: some View {
            Group {
                if children.isEmpty {
                    FilterResultView.ItemView(item: item, filter: filter, role: $role, roles: roles, layout: .tree)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedItem = item
                        }
                } else {
                    DisclosureGroup(key: key, isExpanded: $expansions) {
                        if expansions[key] {
                            ForEach(children, id: \.item) { item in
                                RowView(item: item.item, selectedItem: $selectedItem, role: item.role, roles: item.roles, filter: filter, expansions: $expansions, level: level + 1)
                            }
                        }
                    } label: {
                        FilterResultView.ItemView(item: item, filter: filter, role: $role, roles: roles, layout: .tree)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
            }
        }
    }
}
