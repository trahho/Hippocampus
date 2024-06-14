////
////  ContentView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 23.04.23.
////
//
//import Foundation
//import SwiftUI
//
//struct ContentView: View {
//    @Environment(Navigation.self) var navigation
//    @Environment(Information.self) var information
//
//    var body: some View {
//        if let filter = navigation.filter, let layout = navigation.layout, layout == .list, filter.layouts.contains(.list) {
//            FilterResultView(items: information.items.asArray, filter: filter)
//        } else {
//            FilterSidebarView(expansions: $expansions)
//        }
//    }
//}
//
