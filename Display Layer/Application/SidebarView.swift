//
//  SidebarView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.03.23.
//

import Foundation
import SwiftUI

extension Structure.Filter {
    var children: [Structure.Filter]? {
        subFilter.isEmpty ? nil : subFilter.sorted { $0.name < $1.name }
    }
}

struct SidebarView: View {
    @State var navigation: Navigation
    @Binding var expansions: [Structure.Filter.ID: Bool]

    var body: some View {
        FilterListView(expansions: $expansions)
//            .listStyle(.sidebar)
    }

    struct FilterListView: View {
        @Environment(Navigation.self) var navigation
        @Environment(Structure.self) var structure
        @Binding var expansions: [Structure.Filter.ID: Bool]

        @State var selection: Set<Structure.Filter.ID> = []

        var filters: [Structure.Filter] {
            structure.filters.filter { $0.filter.isEmpty }
                .sorted { $0.name < $1.name }
        }

        var body: some View {
            List(filters) { filter in
                FilterView(filter: filter, expansions: $expansions)
            }
            .listRowSeparator(.hidden)
            .listStyle(.sidebar)
            .onChange(of: selection) { _, _ in
                if selection.isEmpty {
                    navigation.selectedFilter = nil
                } else {
                    navigation.selectedFilter = structure[Structure.Filter.self, selection.first!]
                }
            }
        }
    }

    struct FilterView: View {
        @Environment(Navigation.self) var navigation
        @State var filter: Structure.Filter
        @Binding var expansions: [Structure.Filter.ID: Bool]

        var expansion: Binding<Bool> {
            Binding<Bool>(get: {
                expansions[filter.id] ?? true
            }, set: {
                expansions[filter.id] = $0
            })
        }

        @ViewBuilder var label: some View {
            ZStack {
                if navigation.selectedFilter == filter {
                    RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                        .background(Color.clear)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Image(filter.subFilter.isEmpty ? "light.recessed" : "light.recessed.3")
                    Text("\(filter.name)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    guard navigation.selectedFilter != filter else { return }
                    navigation.selectedFilter = filter
                }
            }
        }

        var body: some View {
            if let children = filter.children {
                DisclosureGroup(isExpanded: expansion) {
                    ForEach(children, id: \.self) { filter in
                        FilterView(filter: filter, expansions: $expansions)
                    }
                } label: {
                    label
                }
            } else {
                label
            }
        }
    }
}



#Preview {
    let document = HippocampusApp.previewDocument()
    let navigation = Navigation()
    @State var expansions: [Structure.Filter.ID: Bool] = [:]

    return NavigationSplitView {
        SidebarView(navigation: navigation, expansions: $expansions)
//    } content: {
//        EmptyView()
    } detail: {
        EmptyView()
    }
    .environment(document)
    .environment(document.structure)
    .environment(navigation)
}
