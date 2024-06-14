//
//  NavigationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import SwiftUI

struct NavigationView: View {
//    @State var document: Document
    @Environment(Information.self) var information
//    @Bindable var navigation: Navigation
    @State var cv: NavigationSplitViewVisibility = .automatic
    @State var expansions: [Structure.Filter.ID: Bool] = [:]
    @State var filter: Structure.Filter?
    @State var index: Int = 0
    @State var path = NavigationPath()

    var twoColumn: Bool {
        return if let filter = filter, let role = filter.role, filter.layouts.contains(.list) { true } else { false }
    }
    
    var filterId: UUID {
        filter?.id ?? Structure.Role.same.id
    }

    @ViewBuilder var filtersList: some View {
        FiltersView(expansions: $expansions, selection: $filter)
    }

    @ViewBuilder var filterResultList: some View {
        if let filter = filter, let _ = filter.role, filter.layouts.contains(.list) {
            FilterResultView(items: information.items.asArray, filter: filter, index: index)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder var detailView: some View {
        NavigationStack(path: $path) {
            ZStack {
//                if let filter = filter, let layout = navigation.layout, layout != .list, filter.layouts.contains(layout) {
                if let filter {
                    FilterResultView(items: information.items.asArray, filter: filter, index: index)
                } else {
                    EmptyView()
                }
            }
        }
    }

    var body: some View {
        Group {
            if twoColumn {
                NavigationSplitView(columnVisibility: $cv) {
                    filtersList
                } content: {
                    filterResultList
                } detail: {
                    detailView
                }
                .id(filterId)
            } else {
                NavigationSplitView(columnVisibility: $cv) {
                    filtersList
                } detail: {
                    detailView
                }
                .id(filterId)
            }
        }
        .onChange(of: filter) { oldValue, newValue in
            print (filter?.name ?? "Nix")
            index += 1
        }
          
//        if let filter = navigation.listFilter {
//        NavigationSplitView(columnVisibility: $cv) {
//            if let filter = filter, let layout = navigation.layout, layout == .list, filter.layouts.contains(.list) {
//                FiltersView(expansions: $expansions)
//            } else {
//                EmptyView()
//            }
//        } content: {
//            if let filter = filter, let layout = navigation.layout, layout == .list, filter.layouts.contains(.list) {
//                FilterResultView(items: information.items.asArray, filter: navigation.filter!)
//            } else {
//                FiltersView(expansions: $expansions)
//            }
//        } detail: {}
//            .onAppear {
//                cv = .automatic
//            }
//            .onChange(of: navigation.filter) { _, _ in
//                print("Selected \(navigation.filter?.name ?? "None")")
//                filter = navigation.filter
//            }
//
        ////        } else {
//            NavigationSplitView {
//                SidebarView(navigation: navigation)
//            } detail: {
//                Color.green
//                DetailView(navigation: navigation)
//            }
//            .onAppear{
//                cv = .all
//            }
//        }
//        #if os(iOS)
//        NavigationSplitView<SidebarView, ContentView, <#Detail: View#>> {
//            SidebarView(presentation: document.presentation)
//        } content: {
//            ContentView()
//        }
//        #else
//        EmptyView()
//        #endif
    }
}

#Preview {
    let document = HippocampusApp.previewDocument()
//    let navigation = Navigation()

    return NavigationView()
//        .environment(navigation)
        .environment(document)
        .environment(document.information)
        .environment(document.structure)
}
