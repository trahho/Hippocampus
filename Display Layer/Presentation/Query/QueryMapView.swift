//
//  QueryMapView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.05.23.
//

import Foundation
import SwiftUI

struct QueryMapView: View {
    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject var document: Document
    @ObservedObject var query: Presentation.Query

    var graph: Presentation.PresentationResult.PresentationGraph {
        Presentation.PresentationResult.PresentationGraph(result: query.apply(to: document.information))
    }

    let nameAspect = Structure.Role.global.name

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
        EmptyView()
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
