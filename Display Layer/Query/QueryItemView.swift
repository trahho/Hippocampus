//
//  QueryItemView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation
import SwiftUI

struct QueryItemView: View {
    @ObservedObject var item: Presentation.Query.Result.Item

    var roles: [Structure.Role] {
        item.roles.sorted { a, b in
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
//            ForEach(item.roles.sorted(by: { $0.roleDescription < $1.roleDescription })) { role in
//                DisclosureGroup(LocalizedStringKey(role.roleDescription)) {
//                    role.representation(for: "_Edit")
//                        .view(for: item.item, editable: true)
//                }
//            }
            EmptyView()
        }
        .padding()
    }
}
