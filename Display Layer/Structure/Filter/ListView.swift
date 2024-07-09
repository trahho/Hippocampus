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
    typealias Result = (item: Information.Item, role: Structure.Role, roles: [Structure.Role])

    @Environment(Information.self) var information
    @Environment(Structure.self) var structure
    @State var filter: Structure.Filter
    @State var expansions = Expansions(defaultExpansion: false)

    var rootItems: [Result] {
        guard !filter.roles.isEmpty else { return [] }
        let allRoles: Information.Condition = filter.roles.reduce(.nil) { partialResult, role in
            partialResult || .role(role.id)
        }
        let rootCondition = allRoles && filter.condition
        let items = information.items.compactMap {
            var roles: [Structure.Role] = []
            return rootCondition.matches($0, structure: structure, roles: &roles) ? Result(item: $0, roles.finalsFirst.first!, roles: roles) : nil
        }
        if let order = filter.order {
            return items.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: structure) })
        } else {
            return items
        }
    }

    var body: some View {
        List {
            ForEach(rootItems, id: \.item) { item in
                HStack {AspectView(item: item.item, aspect: Structure.Role.named[dynamicMember: "name"], appearance: .normal, editable: false)
                    Text("\(item.role.name)")
                }
            }
        }
    }
}
