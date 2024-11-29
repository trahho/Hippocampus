////
////  SidebarView.PerspectivesView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 13.05.23.
////
//
//import SwiftUI
//
//extension SidebarView {
//    struct PerspectivesView: View {
//        @EnvironmentObject var navigation: Navigation
//        @EnvironmentObject var document: Document
//
//        var perspectives: [Structure.Perspective] {
//            document.structure.perspectives
//                .sorted { $0.perspectiveDescription < $1.perspectiveDescription }
//        }
//
//        var body: some View {
//            List(perspectives, id: \.self, selection: $navigation.perspective) { perspective in
//                Text(perspective.perspectiveDescription)
//            }
//        }
//    }
//}
//
//struct PerspectivesView_Previews: PreviewProvider {
//    static let document = HippocampusApp.previewDocument()
//    static let navigation = Navigation()
//    static var previews: some View {
//        SidebarView.PerspectivesView()
//            .environmentObject(document)
//            .environmentObject(navigation)
//    }
//}
