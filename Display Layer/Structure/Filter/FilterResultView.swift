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
//    @State var items: [Information.Item]
    @State var filter: Structure.Filter
    @State var order: Presentation.Order?
    @State var layout: Presentation.Layout?

//    var condition: Information.Condition { .all([filter.roots]) }

//    var sequence: [Presentation.Sequence] {
//        if let order = order ?? orders.first {
//            return [.ordered(condition, order: [order])]
//        } else {
//            return [.unordered(condition)]
//        }
//    }

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

        }
    }
}

//extension FilterResultView {
//    struct Item{
//        let item: Information.Item
//        let role: Structure.Role
//    }
//}
