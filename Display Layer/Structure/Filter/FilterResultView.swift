//
//  FilterResultView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.05.24.
//

import Foundation
import Grisu
import SwiftUI

struct FilterResultView: View {
    @Environment(\.structure) var structure
    @State var filter: Structure.Filter


    var test: Structure.Filter {
        print("\(filter.name) Result")
        return filter
    }

    var body: some View {
        VStack(alignment: .leading) {
            if filter.allRoles.isEmpty {
                EmptyView()
            } else {
                if let layout = filter.layout {
                    switch layout {
                    case .list:
                        ListView(filter: filter)
                    case .tree:
                        TreeView(filter: filter)
                    default:
                        EmptyView()
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .toolbar{
            Picker(selection: $filter.layout) {
                ForEach(Presentation.Layout.allCases, id:\.self) { layout in
                    if filter.allLayouts.contains(layout) {
                        HStack{
                            layout.icon
                            Text(layout.description)
                        }
                        .tag(layout)
                    }
                }
            } label: {
                filter.layout?.icon ?? Image(systemName: "map")
            }
            Menu("", systemImage: "arrow.up.arrow.down") {
                ForEach(filter.orders, id:\.self) { order in
                    Button {
                        filter.order = order
                    } label: {
                        Text(order.textDescription(structure: structure))
                    }
                }
            }
            Picker(selection: $filter.order) {
                ForEach(filter.orders, id:\.self) { order in
                    Text(order.textDescription(structure: structure))
                        .tag(order)
                }
            } label: {
                Text(filter.order?.textDescription(structure: structure) ?? "select order")
            }

        }
    }
}

//extension FilterResultView {
//    struct Item{
//        let item: Information.Item
//        let role: Structure.Role
//    }
//}
