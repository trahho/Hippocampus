//
//  QueryTreeView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.04.23.
//

import Foundation
import SwiftUI

struct QueryTreeView: View {
    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject var document: Document
    @ObservedObject var information: Information
    @ObservedObject var query: Structure.Query

    @State var sortOrder: SortOrder = .forward

    var result: Structure.Query.Result {
        query.apply(to: information)
    }

    let nameAspect = Structure.Role.global.name

    var items: [Structure.Query.Result.Node] {
        result.nodes
            .filter { $0.from.isEmpty }
            .sorted(by: { a, b in
                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
            })
    }

//    var items: [Mind.Idea] {
//        conclusion.ideas.values
//            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
//    }

    @State var selection: Structure.Query.Result.Node?



    func subItems(for item: Structure.Query.Result.Node) -> [Structure.Query.Result.Item] {
        item.to.map { $0.to }
            .sorted(by: { a, b in
                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
            })
    }

//    @ViewBuilder
//    func nodeView(item: Structure.Query.Result.Node) -> some  View {
//        //        DisclosureGroup {
//        Group {
//            let subItems = subItems(for: item)
//            if !subItems.isEmpty {
//                DisclosureGroup {} label: { nodeView(item: item) }
//                //            }
//            } else {
//                representation(for: item)
//            }
//            //        } label: { representation(for: item) }
//        }
//    }

    var body: some View {
        List(items, id: \.self, selection: $navigation.item) { item in
            RowView(query: query, item: item)

//            Text("Test")
//            listItem.view(for: item.item, by: document.structure, editable: false)
                .padding(2)
//                .frame(maxWidth: .infinity)
//                .background(.blue)
                .tapToSelectItem(item)
        }
    }
    
    struct RowView: View {
        @EnvironmentObject var navigation: Navigation
        @ObservedObject var query: Structure.Query
        @ObservedObject var item: Structure.Query.Result.Node
        
        let nameAspect = Structure.Role.global.name

        var subItems: [Structure.Query.Result.Node] {
            item.to.map { $0.to }
                .sorted(by: { a, b in
                    a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
                })
        }
        
        @ViewBuilder
        func representation(for item: Structure.Query.Result.Item) -> some View {
            let representation = item.roles.compactMap {
                if let representation = query.roleRepresentation(role: $0, layout: .list) {
                    return $0.representation(for: representation)
                }
                return nil
            }.first ?? Structure.Query.defaultRepresentation

            representation.view(for: item.item)
        }
        
        var body: some View {
            if subItems.isEmpty {
                representation(for: item)
            } else {
                DisclosureGroup {
                    List(subItems, id: \.self, selection: $navigation.item) { item in
                        RowView(query: query, item: item)
                    }
                } label: {
                    representation(for: item)
                }
            }
        }
    }
}
