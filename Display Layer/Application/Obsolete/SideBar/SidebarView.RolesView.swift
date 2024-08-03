////
////  SidebarView.RolesView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 13.05.23.
////
//
//import SwiftUI
//
//extension SidebarView {
//    struct RolesView: View {
//        @EnvironmentObject var navigation: Navigation
//        @EnvironmentObject var document: Document
//
//        var roles: [Structure.Role] {
//            document.structure.roles
//                .sorted { $0.roleDescription < $1.roleDescription }
//        }
//
//        var body: some View {
//            List(roles, id: \.self, selection: $navigation.role) { role in
//                Text(role.roleDescription)
//            }
//        }
//    }
//}
//
//struct RolesView_Previews: PreviewProvider {
//    static let document = HippocampusApp.previewDocument()
//    static let navigation = Navigation()
//    static var previews: some View {
//        SidebarView.RolesView()
//            .environmentObject(document)
//            .environmentObject(navigation)
//    }
//}
