////
////  SidebarView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 01.06.24.
////
//
//import SwiftUI
//
//struct SidebarView: View {
//    @Environment(Navigation.self) var navigation
//    @Binding var expansions: [Structure.Filter.ID: Bool]
//
//    var body: some View {
//        if let filter = navigation.filter, let layout = navigation.layout, layout == .list, filter.layouts.contains(.list) {
//            FilterSidebarView(expansions: $expansions)
//        } else {
//            EmptyView()
//        }
//    }
//}
//
