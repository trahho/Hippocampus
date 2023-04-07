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
    @ObservedObject var query: Structure.Query

    @State var sortOrder: SortOrder = .forward

    var result: Structure.Query.Result {
        query.apply(to: information)
    }

    var content: [Structure.Query.Result.Item] {
        result.nodes.asArray
            .sorted { a, b in
                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
            }
    }

    let nameAspect = Structure.Role.global.name

    var items: [Structure.Query.Result.Node] {
        result.nodes
            .sorted(by: { a, b in
                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
            })
    }

//    var items: [Mind.Idea] {
//        conclusion.ideas.values
//            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
//    }

    @State var selection: Structure.Query.Result.Item?

    @ViewBuilder
    func representation(for item: Structure.Query.Result.Item) -> some View {
        let representation = item.roles.compactMap { query.roleRepresentation(role: $0, layout: .list) }.first
        if let representation {
            representation.view(for: item.item, by: document.structure)
        } else {
            EmptyView()
        }
    }

    var body: some View {
        List(items, id: \.self, selection: $navigation.item) { item in
            representation(for: item)
//            Text("Test")
//            listItem.view(for: item.item, by: document.structure, editable: false)
                .padding(2)
                .tapToSelectItem(item)
        }
    }
}
