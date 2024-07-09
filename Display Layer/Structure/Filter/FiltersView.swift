//
//  SidebarView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.03.23.
//

import Foundation
import SwiftUI
import Grisu

// extension Structure.Filter {
//    var children: [Structure.Filter]? {
//        subFilter.isEmpty ? nil : subFilter.sorted { $0.name < $1.name }
//    }
// }

struct FiltersView: View {
    @Environment(Structure.self) var structure
    @Binding var expansions: Expansions
    @Binding var selection: Structure.Filter?

    var filters: [Structure.Filter] {
        structure.filters.filter { $0.superFilter.isEmpty }
            .sorted { $0.name < $1.name }
    }

    var body: some View {
        List(filters) { filter in
            FilterView(filter: filter, selected: $selection, expansions: $expansions)
                .listRowSeparator(.hidden)
        }
        .listStyle(.sidebar)
    }
}

//struct FilterDetailView: View {
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
//}

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
