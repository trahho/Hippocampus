////
////  SidebarView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 18.03.23.
////
//
//import Foundation
//import SwiftUI
//
//struct SidebarView: View {
//    @EnvironmentObject var navigation: Navigation
//
//    var body: some View {
//        Group {
//            switch navigation.sidebarMode {
//            case .roles:
//                RolesView()
//            case .queries:
//                QueriesView()
//            default:
//                Text("Not Yet")
//            }
//        }
//        .font(.myText)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text(LocalizedStringKey(navigation.sidebarMode.text))
////                Text(LocalizedStringKey(":pinned"))
//                    .font(.myTitle)
//            }
//            ToolbarItem(placement: .automatic) {
//                Picker(selection: $navigation.sidebarMode) {
//                    ForEach(Navigation.SidebarMode.allCases) { mode in
//                        Label(LocalizedStringKey(mode.text), systemImage: mode.icon)
//                            .font(.myText)
//                    }
//                } label: {
//                    Image(systemName: navigation.sidebarMode.icon)
//                }
//                .pickerStyle(.menu)
//            }
//        }
//    }
//}
//
//struct SidebarView_Previews: PreviewProvider {
//    static let document = HippocampusApp.previewDocument()
//    static let navigation = Navigation()
//    static var previews: some View {
//        NavigationSplitView {
//            SidebarView()
//        } detail: {
//            EmptyView()
//        }
//        .environmentObject(document)
//        .environmentObject(navigation)
//    }
//}
