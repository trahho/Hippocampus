//
//  QueryListView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.03.23.
//

import Foundation
import SwiftUI

struct QueryListView: View {
    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject var document: Document
    @ObservedObject var information: Information
    @ObservedObject var query: Presentation.Query

    @State var sortOrder: SortOrder = .forward

    var result: Presentation.Query.Result {
        query.apply(to: information)
    }

    let nameAspect = Structure.Role.global.name

    var items: [Presentation.Query.Result.Node] {
        result.nodes
            .sorted(by: { a, b in
                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
            })
    }

//    var items: [Mind.Idea] {
//        conclusion.ideas.values
//            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
//    }

    @State var selection: Presentation.Query.Result.Item?

    @ViewBuilder
    func representation(for item: Presentation.Query.Result.Item) -> some View {
        let representation = item.roles.compactMap {
            if let representation = query.roleRepresentation(role: $0, layout: .list) {
                return representation.role.representation(for: representation.representation)
            }
            return nil
        }.first ?? Presentation.Query.defaultRepresentation

        representation.view(for: item.item)
    }

    var body: some View {
        List(items, id: \.self) { item in
            representation(for: item)
//            Text("Test")
//            listItem.view(for: item.item, by: document.structure, editable: false)
                .padding(2)
                .onTapGesture {
                    query.items.append(Presentation.ItemDetail(item: item.item, roles: item.roles.asArray))
                }
//                .frame(maxWidth: .infinity)
//                .background(.blue)
//                .tapToSelectItem(item)
        }
    }
}
