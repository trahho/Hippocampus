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
    @ObservedObject var query: Presentation.Query

    @State var sortOrder: SortOrder = .forward

    var result: Presentation.PresentationResult.Result {
        query.apply(to: document.information)
    }

    let nameAspect = Structure.Role.global.name
//
    var items: [Presentation.PresentationResult.Item] {
        result.items
//            .filter(\.from.isEmpty)
            .sorted(by: { a, b in
                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
            })
    }

//
    ////    var items: [Mind.Idea] {
    ////        conclusion.ideas.values
    ////            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
    ////    }
//
//    @State var selection: Presentation.Node?

//    func subItems(for item: Presentation.Node) -> [Presentation.Item] {
    ////        item.to
    //////            .map(\.to)
    ////            .sorted(by: { a, b in
    ////                a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
    ////            })
//        []
//    }

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
    
    @ViewBuilder
    func representation(for item: Presentation.PresentationResult.Item) -> some View {
        let representation = item.roles.compactMap {
            if let representation = query.roleRepresentation(role: $0, layout: .list) {
                return representation.role.representation(for: representation.representation)
            }
            return nil
        }.first ?? Presentation.Query.defaultRepresentation

        representation.view(for: item.item)
    }

    var body: some View {
        List(items, id: \.self, children: \.nextArray) { item in
            representation(for: item)

//            Text("Test")
//            listItem.view(for: item.item, by: document.structure, editable: false)
//                .padding(2)
//                .frame(maxWidth: .infinity)
//                .background(.blue)
//                .tapToSelectItem(item)
                .onTapGesture {
                    navigation.path.append(item)
                }
        }
//        EmptyView()
    }

    struct RowView: View {
        @EnvironmentObject var navigation: Navigation
        @ObservedObject var query: Presentation.Query
        @ObservedObject var item: Presentation.PresentationResult.Item
        @State var isExpanded = false

        let nameAspect = Structure.Role.global.name

        var subItems: [Presentation.PresentationResult.Item] {
            item.next
                .sorted(by: { a, b in
                    a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
                })
        }

        @ViewBuilder
        func representation(for item: Presentation.PresentationResult.Item) -> some View {
            let representation = item.roles.compactMap {
                if let representation = query.roleRepresentation(role: $0, layout: .list) {
                    return representation.role.representation(for: representation.representation)
                }
                return nil
            }.first ?? Presentation.Query.defaultRepresentation

            representation.view(for: item.item)
        }

        var body: some View {
            if subItems.isEmpty {
                representation(for: item)
            } else {
                DisclosureGroup(isExpanded: $isExpanded) {
                    List(subItems, id: \.self) { subItem in
                        RowView(query: query, item: subItem)
                    }
                } label: {
                    representation(for: item)
                }
            }
        }
    }
}
