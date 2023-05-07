//
//  NavigationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import SwiftUI

struct NavigationView: View {
    @EnvironmentObject var document: Document
    @EnvironmentObject var navigation: Navigation

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            ContentView()
        }
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
