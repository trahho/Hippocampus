//
//  QueryItemView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation
import SwiftUI

struct QueryItemView: View {
    @ObservedObject var item: Structure.Query.Result.Item

    var roles: [Structure.Role] {
        item.roles.sorted { a, b in
            a.roleDescription < b.roleDescription
        }
    }

    func aspects(_ role: Structure.Role) -> [Structure.Aspect] {
        role.allAspects.sorted { a, b in
            a.name < b.name
        }
    }

//    var body: some View {
//        Text("Depp")
//    }

    var body: some View {
        ScrollView {
//        List {
//            Text("A")
//            Text("B")
            ////        }
//            VStack(alignment: .leading) {
                ForEach(item.roles.sorted(by: { $0.roleDescription < $1.roleDescription })) { role in
                    DisclosureGroup(role.roleDescription) {
                        ForEach(aspects(role)) { aspect in
//                                            Text(aspect.name)
                            aspect.view(for: item.item, as: .small, editable: false)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
//                Text("\(role.roleDescription)")
                }
//            }
        }
        .padding()
    }
}

