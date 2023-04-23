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
        } content: {
            ContentView()
        }
    }
}
