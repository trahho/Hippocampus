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
    // MARK: Properties

    @Environment(\.structure) var structure
    @State var filter: Structure.Filter
    @State var showAddPopover = false

    // MARK: Computed Properties

    var result: Structure.Filter.Result {
        return filter.result
    }

    // MARK: Content

    var body: some View {
        VStack(alignment: .leading) {
            if filter.allRoles.isEmpty {
                EmptyView()
            } else {
                if let layout = filter.layout {
                    switch layout {
                    case .list:
                        ListView(result: result)
                    case .tree:
                        TreeView(result: result)
                    default:
                        Text("Layout not implemented")
                    }
                } else {
                    Text("Select layout")
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .secondaryAction) {
                PopoverMenu {
                    ForEach(Presentation.Layout.allCases.filter { filter.allLayouts.contains($0) }, id: \.self) { layout in
                        HStack {
                            layout.icon
                            Text(layout.description)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(3)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(filter.layout == layout ? Color.accentColor : Color.clear)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            filter.layout = layout
                        }
                    }
                    .padding()
                } label: {
                    filter.layout?.icon ?? Image(systemName: "map")
                }

                PopoverMenu {
                    ForEach(filter.orders, id: \.self) { order in
                        Text(order.textDescription(structure: structure))
                            .frame(maxWidth: .infinity)
                            .padding(3)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(filter.order == order ? Color.accentColor : Color.clear)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                filter.order = order
                            }
                    }
                    .padding()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }

//            PopoverMenu {
//                ForEach(filter.orders, id: \.self) { order in
//                    Text(order.textDescription(structure: structure))
            ////                        .frame(maxWidth: .infinity)
            ////                        .padding(3)
            ////                        .background {
            ////                            RoundedRectangle(cornerRadius: 4)
            ////                                .foregroundStyle(filter.order == order ? Color.accentColor : Color.clear)
            ////                        }
            ////                        .contentShape(Rectangle())
            ////                        .onTapGesture {
            ////                            filter.order = order
            ////                        }
//                }
//            } label: {
//                Image(systemImage: "arrow.up.arrow.down")
//            }

//            Picker(selection: $filter.order) {
//                ForEach(filter.orders, id: \.self) { order in
//                    Text(order.textDescription(structure: structure))
//                        .tag(order)
//                }
//            } label: {
//                Text(filter.order?.textDescription(structure: structure) ?? "select order")
//            }
        }
    }

    // MARK: Functions

    func create(role: Structure.Role) {
        let item = structure(Information.Item.self)
        item.roles.append(role)
    }
}

// extension FilterResultView {
//    struct Item{
//        let item: Information.Item
//        let role: Structure.Role
//    }
// }
