//
//  ContentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var navigation: Navigation
    @Environment(Information.self) var information

    var body: some View {
        if let filter = navigation.listFilter, let role = filter.role {
            FilterListView(items: information.items.asArray, filter: filter)
        } else {
            EmptyView()
        }
    }
}

struct FilterListView: View {
    @State var items: [Information.Item]
    @State var filter: Structure.Filter
    @State var order: Presentation.Order?

    var orders: [Presentation.Order] { filter.order }
    var condition: Information.Condition { .all(filter.allConditions) }

    var sequence: [Presentation.Sequence] {
        if let order = order ?? orders.first {
            return [.ordered(condition, order: [order])]
        } else {
            return [.unordered(condition)]
        }
    }

    var body: some View {
        SequenceView(items: items, sequences: sequence, layout: .list)
    }
}
