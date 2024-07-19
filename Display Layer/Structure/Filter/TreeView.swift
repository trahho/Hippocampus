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
//                HStack {
//                    Text("\(item.roles.count)")
                ListRowView(item: item.item, role: item.role, roles: item.roles, filter: filter, expansions: $expansions)
//                }
            }
        }
    }
}

extension TreeView {
    struct ListRowView: View {
        // MARK: Nested Types

        struct ItemPresentationView: View {
            // MARK: Properties

            @State var item: Information.Item
            @State var presentation: Presentation?

            // MARK: Content

            var body: some View {
                Group {
                    if let presentation {
                        PresentationView(presentation: presentation, item: item)
                    } else {
                        Image(systemName: "questionmark.square.dashed")
                    }
                }
                .sensitive
            }
        }

        // MARK: Properties

        @Environment(\.information) var information
        @Environment(\.structure) var structure
        @State var item: Information.Item
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
        
        var filterPresentation: Presentation? {
            filter.representations.filter { $0.condition.matches(item, sameRole: role, structure: structure) }.first?.presentation
        }

        var rolePresentation: Presentation? {
                role.representation(layout: .tree)?.presentation
        }
        
        var presentation: Presentation? {
            filterPresentation ?? rolePresentation
        }

        // MARK: Content

        var body: some View {
            Group {
                if children.isEmpty {
                    ItemPresentationView(item: item, presentation: presentation).sensitive
                        .contextMenu {
                            Picker("Role", selection: $role) {
                                ForEach(roles) { role in
                                    Text(role.name)
                                        .tag(role)
                                }
                            }
                        }
                } else {
                    DisclosureGroup(key: key, isExpanded: $expansions) {
                        if expansions[key] {
                            ForEach(children, id: \.item) { item in
                                ListRowView(item: item.item, role: item.role, roles: item.roles, filter: filter, expansions: $expansions, level: level + 1)
                            }
                        }
                    } label: {
                        ItemPresentationView(item: item, presentation: presentation).sensitive
                    }
                    .contextMenu {
                        Picker("Role", selection: $role) {
                            ForEach(roles) { role in
                                Text(role.name)
                                    .tag(role)
                            }
                        }
                    }
                }
            }
        }
    }
}
