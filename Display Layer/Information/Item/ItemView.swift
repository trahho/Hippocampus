////
////  QueryItemView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 25.03.23.
////
//
//import Foundation
//import SwiftUI
//
//struct ItemView: View {
//    @EnvironmentObject var document: Document
//    @ObservedObject var item: Information.Item
//    var perspectives: [Structure.Perspective]
//    @State var showAllPerspectives = false
//
//    var sortedPerspectives: [Structure.Perspective] {
//        let perspectives = showAllPerspectives ? document.structure.perspectives.filter { item[perspective: $0] } : perspectives
//        return perspectives.sorted { a, b in
//            a.perspectiveDescription < b.perspectiveDescription
//        }
//    }
//
//    func aspects(_ perspective: Structure.Perspective) -> [Structure.Aspect] {
//        perspective.allAspects.sorted { a, b in
//            (a.index, a.name) < (b.index, b.name)
//        }
//    }
//
////    var body: some View {
////        Text("Depp")
////    }
//
//    var body: some View {
//        //        ScrollView {
//        //            ForEach(sortedPerspectives) { perspective in
//        //                DisclosureGroup(LocalizedStringKey(perspective.perspectiveDescription)) {
//        //                    perspective.representation(for: "_Edit")
//        //                        .view(for: item, editable: true)
//        //                }
//        //            }
//        //            EmptyView()
//        //        }
//        //        .padding()
//        TabView {
//            ForEach(sortedPerspectives) { perspective in
//                VStack {
//                    perspective.representation(for: "_Edit")
//                        .view(for: item, editable: true)
//                }
//                .tabItem {
//                    Text(LocalizedStringKey(perspective.perspectiveDescription))
//                }
//            }
//        }
//    }
//}
