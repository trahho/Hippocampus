////
////  Design.NavigationView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 02.06.24.
////
//
//import SwiftUI
//
//struct Design_NavigationView: View {
//    @Environment(Design_NavigationView.Navigation.self) var navigation
//    @State private var columnVisibility: NavigationSplitViewVisibility = .all
//
//    @State var content: [Int]
//        = Array(1 ..< 11)
//
//    var sidebarList: some View {
//        List(content, id: \.self) { int in
//            ZStack {
//                if navigation.selectedInt ?? -1  == int {
//                    RoundedRectangle(cornerRadius: 6)
//                        .foregroundColor(.accent)
//                }
//                Text("Row \(int)") // , value: int)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        navigation.selectedInt = int
//                    }
//                    .padding(6)
//            }
//            .listRowSeparator(.hidden)
//        }
//        .listStyle(.sidebar)
//    }
//
//    var contentView: some View {
//        Text("Content \(navigation.selectedInt ?? 0)")
//    }
//
//    var detailView: some View {
//        Text("Detail \(navigation.selectedInt ?? 0)")
//    }
//
//    var body: some View {
//        Group {
//            // Only rows that are a multiple of 2 will have a two-column layout
//            if navigation.selectedInt?.isMultiple(of: 2) == true {
//                NavigationSplitView(columnVisibility: $columnVisibility) {
//                    sidebarList
//                } detail: {
//                    detailView
//                }
//            } else {
//                NavigationSplitView(columnVisibility: $columnVisibility) {
//                    sidebarList
//                } content: {
//                    contentView
//                } detail: {
//                    detailView
//                }
//            }
//        }
//        .navigationSplitViewStyle(.balanced)
//    }
//
//    @Observable class Navigation {
//        var selectedInt: Int? = 1
//    }
//}
//
//#Preview {
//    let navigation = Design_NavigationView.Navigation()
//    return Design_NavigationView()
//        .environment(navigation)
//}
