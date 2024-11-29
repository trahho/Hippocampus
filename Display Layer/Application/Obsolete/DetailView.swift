////
////  DetailView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 27.05.24.
////
//
//import SwiftUI
//
//struct DetailView: View {
//    @Environment(Information.self) var information
//    @Environment(Navigation.self) var navigation
//
//    var body: some View {
//        NavigationStack(path: $navigation.path) {
////            if navigation.sidebarMode == .queries, let query = navigation.query {
////                QueryView(query: query)
////                    .navigationDestination(for: Presentation.PresentationResult.Item.self) { item in
////                        ItemView(item: item.item, perspectives: item.perspectives.asArray)
////                    }
////            } else if navigation.sidebarMode == .perspectives, let perspective = navigation.perspective {
////                PerspectiveView(perspective: perspective)
//            ////                    .navigationDestination(for: Structure.Perspective.self) { item in
//            ////                        ItemView(item: item.item, perspectives: item.perspectives.asArray)
//            ////                    }
////            } else {
//            ZStack(alignment: .topLeading){
//                
//                if let filter = navigation.filter, let layout = navigation.layout, layout != .list, filter.layouts.contains(layout) {
//                    FilterResultView(items: information.items.asArray, filter: filter)
//                } else {
//                    EmptyView()
//                }
//            }
////                .navigationDestination(for: Structure.Filter.self) { filter in
////                   
////                }
////            }
//        }
//    }
//}
//
////#Preview {
////    DetailView(navigation: Navigation())
////}
