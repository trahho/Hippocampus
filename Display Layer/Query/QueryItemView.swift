//
//  QueryItemView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation
import SwiftUI

struct QueryItemView: View {
    @EnvironmentObject var document: Document
    @ObservedObject var item: Information.Item
    var roles: Set<Structure.Role>
    @State var showAllRoles = false

    var sortedRoles: [Structure.Role] {
        let roles = showAllRoles ? document.roles.filter { item[role: $0] } : roles
        return roles.sorted { a, b in
            a.roleDescription < b.roleDescription
        }
    }

    func aspects(_ role: Structure.Role) -> [Structure.Aspect] {
        role.allAspects.sorted { a, b in
            (a.index, a.name) < (b.index, b.name)
        }
    }

//    var body: some View {
//        Text("Depp")
//    }

    var body: some View {
        ScrollView {
            ForEach(sortedRoles) { role in
                DisclosureGroup(LocalizedStringKey(role.roleDescription)) {
                    role.representation(for: "_Edit")
                        .view(for: item, editable: true)
                }
            }
            EmptyView()
        }
        .padding()
    }
}
