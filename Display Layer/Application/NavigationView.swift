//
//  NavigationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Grisu
import SwiftUI

struct NavigationView: View {
    // MARK: Properties

//    @State var document: Document
    @Environment(\.information) var information
//    @Bindable var navigation: Navigation
    @State var cv: NavigationSplitViewVisibility = .automatic
    @State var expansions = Expansions()
    @State var filter: Structure.Filter?
    @State var index: Int = 0
    @State var path = NavigationPath()

    // MARK: Computed Properties

    var twoColumn: Bool {
        guard let filter = filter, !filter.roles.isEmpty else { return false }
        return [.list, .tree].contains(filter.layout)
    }

    var filterId: UUID {
        filter?.id ?? Structure.Role.same.id
    }

    // MARK: Content

    @ViewBuilder var filtersList: some View {
        FiltersView(expansions: $expansions, selection: $filter)
    }

    @ViewBuilder var filterResultList: some View {
        if let filter = filter, !filter.roles.isEmpty {
            FilterResultView(filter: filter)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder var detailView: some View {
        NavigationStack(path: $path) {
            ZStack {
//                if let filter = filter, let layout = navigation.layout, layout != .list, filter.layouts.contains(layout) {
                if !twoColumn, let filter {
                    FilterResultView(filter: filter)
                } else {
                    EmptyView()
                }
            }
        }
    }

    var body: some View {
        Group {
            if twoColumn {
                NavigationSplitView {
                    filtersList
                } content: {
                    filterResultList
                } detail: {
                    detailView
                }
                .id(filterId)
            } else {
                NavigationSplitView {
                    filtersList
                } detail: {
                    detailView
                }
                .id(filterId)
            }
        }
    }
}

#Preview {
    var document = HippocampusApp.previewDocument
//    let navigation = Navigation()

     NavigationView()
        .environment(\.currentDocument, document)
 
}

extension View {
    func debugPrint(_ text: String) -> some View {
        print(text)
        return self
    }
}
