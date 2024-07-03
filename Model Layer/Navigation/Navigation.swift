//
//  NavigationModel.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.03.23.
//

import Foundation
import SwiftUI

@Observable class Navigation {
    var filter: Structure.Filter?
    {
        didSet {
            print(filter?.name ?? "Leer")
        }
    }
//    {
//        didSet {
//            if let selectedFilter, let role = selectedFilter.role {
//                if selectedFilter.layouts.contains(.list) {
//                    path.removeLast(path.count)
////                    path = NavigationPath()
//                    listFilter = selectedFilter
//                    detailFilter = nil
//                } else {
//                    listFilter = nil
//                    detailFilter = selectedFilter
//                    path.removeLast(path.count)
////                    path = NavigationPath()
//                }
//            } else {
//                path.removeLast(path.count)
////                path = NavigationPath()
//                listFilter = nil
//                detailFilter = nil
//            }
//        }
//    }

    var layout: Presentation.Layout? = .list
 
    var path = NavigationPath()
}

// class Navigation: ObservableObject {
//
//    @Published var sidebarMode: SidebarMode = .roles
//    @Published var role: Structure.Role?
//    @Published var query: Presentation.Query?
//    @Published var path = NavigationPath()
//
//
// }

// extension Navigation {
//    struct SelectQueryModifier: ViewModifier {
//        @EnvironmentObject var navigation: Navigation
//        var query: Presentation.Query
//
//        func body(content: Content) -> some View {
//            content
//                .contentShape(Rectangle())
//                .onTapGesture {
////                    withAnimation {
//                    navigation.showQuery(query: query)
////                    }
//                }
//        }
//    }
//
//    struct SelectItemModifier: ViewModifier {
//        @EnvironmentObject var navigation: Navigation
//        var item: Presentation.Query.Result.Item
//
//        func body(content: Content) -> some View {
//            content
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    navigation.showItem(item: item.item, roles: item.roles)
//                }
//        }
//    }
//
//    struct MoveBackModifier: ViewModifier {
//        @EnvironmentObject var navigation: Navigation
//
//        func body(content: Content) -> some View {
//            content
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    navigation.moveBack()
//                }
//        }
//    }
// }
//
// extension View {
//    func tapToSelectQuery(_ query: Presentation.Query) -> some View {
//        modifier(Navigation.SelectQueryModifier(query: query))
//    }
//
//    func tapToSelectItem(_ item: Presentation.Query.Result.Item) -> some View {
//        modifier(Navigation.SelectItemModifier(item: item))
//    }
//
//    func tapToRemoveLastSelectedItem() -> some View {
//        modifier(Navigation.MoveBackModifier())
//    }
// }
