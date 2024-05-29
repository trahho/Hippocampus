//
//  NavigationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import SwiftUI

struct NavigationView: View {
//    @State var document: Document
    @Environment(Navigation.self) var navigation
    @State var cv: NavigationSplitViewVisibility = .automatic
    @State var expansions: [Structure.Filter.ID: Bool] = [:]

    var body: some View {
//        if let filter = navigation.listFilter {
        NavigationSplitView(columnVisibility: $cv) {
            if let filter = navigation.listFilter {
                SidebarView(navigation: navigation, expansions: $expansions)
            } else {
                Color.red
            }
        } content: {
            if let filter = navigation.listFilter {
                ContentView(navigation: navigation)
            } else {
                SidebarView(navigation: navigation, expansions: $expansions)
            }
        } detail: {
            DetailView(navigation: navigation)
        }
        .onAppear {
            cv = .automatic
        }
    
//        } else {
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

    return NavigationView()
        .environment(Navigation())
        .environment(document)
        .environment(document.information)
        .environment(document.structure)
}
