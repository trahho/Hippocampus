////
////  SidebarView.QueriesView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 13.05.23.
////
//
//import Foundation
//import SwiftUI
//
//extension SidebarView {
//    struct QueriesView: View {
//        @EnvironmentObject var navigation: Navigation
//        @EnvironmentObject var document: Document
//        @State var editItem: Presentation.Object?
//        @State var selection: Presentation.Query?
//        
//        var groups: [Presentation.Group] {
//            document.presentation.groups
//                .filter { $0.isTop }
//                .sorted { $0.name < $1.name }
//        }
//        
//        var queries: [Presentation.Query] {
//            document.presentation.queries
//                .filter { $0.isTop }
//                .sorted { $0.name < $1.name }
//        }
//        
//        @ViewBuilder var content: some View {
//            ForEach(groups) { group in
//                SidebarView.GroupView(group: group, editItem: $editItem)
//            }
//            ForEach(queries) { query in
//                SidebarView.QueryView(query: query, editItem: $editItem)
//            }
//        }
//        
//        var body: some View {
//            VStack(alignment: .leading) {
//                List(selection: $navigation.query) {
//                    content
////                        .listRowSeparator(.hidden)
//                }
//                .listStyle(.sidebar)
////                .sheet(item: $editItem) { item in
////                    QueryEditView(groupItem: item)
////                }
//            }
//        }
//    }
//}
