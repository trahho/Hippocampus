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

    let listItem: Structure.Representation = .aspect(Structure.Role.global.name, form: .small, editable: false)

//    var items: [Mind.Idea] {
//        conclusion.ideas.values
//            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
//    }
    
    @State var selection: Structure.Query.Result.Item?

    var body: some View {
        let nameAspect = Structure.Role.note.name
        let items = result.nodes
            .map { $0 as Structure.Query.Result.Item }
            .sorted(by: { a, b in
                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
            })
        List(items, id:\.self, selection: $navigation.item) { item in
            listItem.view(for: item.item, by: document.structure, editable: false)
                .padding(2)
//                .tapToSelectItem(item)
        }
    }
}
