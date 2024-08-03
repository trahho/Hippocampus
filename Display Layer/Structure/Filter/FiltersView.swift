//
//  SidebarView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.03.23.
//

import Foundation
import Grisu
import SwiftUI

// extension Structure.Filter {
//    var children: [Structure.Filter]? {
//        subFilter.isEmpty ? nil : subFilter.sorted { $0.name < $1.name }
//    }
// }

struct FiltersView: View {
    // MARK: Properties

//    @Environment(\.structure) var structure
    @State var structure: Structure
    @Environment(\.openWindow) var openWindow
    @Binding var expansions: Expansions

    // MARK: Computed Properties

    var filters: [Structure.Filter] {
        let structure = self.structure
        let filters = structure.filters
        let result = filters.filter { $0.superFilters.isEmpty }
            .sorted { $0.description < $1.description }
        return result
    }

    // MARK: Content

    var body: some View {
        @Bindable var structure = structure
        NestedList(data: filters, selection: $structure.selectedFilterId) { filter in
            HStack {
//                Image(systemName: filter.subFilters.isEmpty ? "light.recessed.fill" : "light.recessed.3.fill")
                Text("\(filter.description)")
            }
        } children: { filter in
            guard !filter.subFilters.isEmpty else { return nil }
            return filter.subFilters.sorted { $0.description < $1.description }
        }
        .listStyle(.sidebar)
        .contextMenu(forSelectionType: Structure.Filter.ID.self) { items in
            if items.isEmpty {
                EmptyView()
            } else {
                Button("Edit") {
                    openWindow(value: items.first!)
                }
            }
        }
    }
}

// struct FilterDetailView: View {
//    @Environment(Structure.self) var structure
//    @Binding var expansions: [Structure.Filter.ID: Bool]
//
//    var filters: [Structure.Filter] {
//        structure.filters.filter { $0.filter.isEmpty }
//            .sorted { $0.name < $1.name }
//    }
//
//    var body: some View {
//        List(filters) { filter in
//            FilterView(filter: filter, expansions: $expansions)
//        }
//        .listRowSeparator(.hidden)
//    }
// }

// #Preview {
//    let document = HippocampusApp.previewDocument()
//    let navigation = Navigation()
//    @State var expansions: [Structure.Filter.ID: Bool] = [:]
//
//    return NavigationSplitView {
//        FilterSidebarView(navigation: navigation, expansions: $expansions)
////    } content: {
////        EmptyView()
//    } detail: {
//        EmptyView()
//    }
//    .environment(document)
//    .environment(document.structure)
//    .environment(navigation)
// }
