//
//  NavigationModel.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.03.23.
//

import Foundation
import SwiftUI

class Navigation: ObservableObject {
    @Published var sidebar: Sidebar = .queries
//    @Published var details: [Detail] = []

    //    @Published var query: Structure.Query?

//    var detail: Detail? {
//        details.last
//    }

//    var query: Presentation.Query? {
//        get {
//            details.compactMap {
//                if case let Detail.query(query) = $0 {
//                    return query
//                } else {
//                    return nil
//                }
//            }.last
//        }
//        set {
//            guard let newValue else { return }
//            showQuery(query: newValue)
//        }
//    }
    @Published var query: Presentation.Query?
    
    var items: [Presentation.ItemDetail] {
        get {
            query?.items ?? []
        }
        set {
            query?.items = newValue
        }
    }

//    func showQuery(query: Presentation.Query) {
//        guard query != self.query else { return }
    ////        withAnimation {
//        if case Detail.query? = detail {
//            details.removeLast()
//        }
//        details.append(.query(query))
    ////        }
//    }

    func showItem(item: Information.Item, roles: [Structure.Role]) {
//        withAnimation {
        query?.items.append(Presentation.ItemDetail(Item: item, Roles: roles))
//        }
    }

    func moveBack() {
//        withAnimation {
        query?.items.removeLast()
//        }
    }
}

//extension Navigation {
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
//}
//
//extension View {
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
//}
