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
    @Published var items: [Structure.Query.Result.Item] = []

    //    @Published var query: Structure.Query?

    @Published private var _query: Structure.Query?
    var query: Structure.Query? {
        get { _query }
        set {
            guard newValue != _query else { return }
            items = []
            _query = newValue
        }
    }

    var item: Structure.Query.Result.Item? {
        get { items.last }
        set {
            withAnimation {
                if let newValue {
                    items = [newValue]
                } else {
                    items = []
                }
            }
        }
    }

    func addItem(_ item: Structure.Query.Result.Item) {
        items.append(item)
    }

    func removeItem() {
        items.removeLast()
    }
}

extension Navigation {
    struct SelectQueryModifier: ViewModifier {
        @EnvironmentObject var navigation: Navigation
        var query: Structure.Query

        func body(content: Content) -> some View {
            content
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        navigation.query = query
                    }
                }
        }
    }

    struct SelectItemModifier: ViewModifier {
        @EnvironmentObject var navigation: Navigation
        var item: Structure.Query.Result.Item

        func body(content: Content) -> some View {
            content
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        navigation.items.append(item)
                    }
                }
        }
    }

    struct RemoveItemModifier: ViewModifier {
        @EnvironmentObject var navigation: Navigation

        func body(content: Content) -> some View {
            content
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        navigation.removeItem()
                    }
                }
        }
    }
}

extension View {
    func tapToSelectQuery(_ query: Structure.Query) -> some View {
        modifier(Navigation.SelectQueryModifier(query: query))
    }

    func tapToSelectItem(_ item: Structure.Query.Result.Item) -> some View {
        modifier(Navigation.SelectItemModifier(item: item))
    }

    func tapToRemoveLastSelectedItem() -> some View {
        modifier(Navigation.RemoveItemModifier())
    }
}
