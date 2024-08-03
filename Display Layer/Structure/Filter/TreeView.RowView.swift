////
////  TreeView.RowView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 19.07.24.
////
//
//import Grisu
//import SwiftUI
//
//extension TreeView {
//    struct RowView: View {
//        // MARK: Properties
//
//        @Environment(\.information) var information
//        @Environment(\.structure) var structure
//        @State var item: Structure.Filter.Result.Item
//        @Binding var expansions: Expansions
//        @State var level: Int = 0
//
//        // MARK: Computed Properties
//
////        var condition: Information.Condition? {
////            filter.leafs ?? filter.roots
////        }
//
//        var key: String {
//            item.id.uuidString + String(level)
//        }
//
//        var children: [Structure.Filter.Result.Item] {
////            let condition: Information.Condition = .isReferenceOfRole(item.role.id)
//
//            //        print("children: \(item.id.uuidString) expanded: \(expansions[item.id.uuidString])")
//            //        let fullcondition: Information.Condition = if let leafs = filter.leafs { .all([.isReferenceOfRole(filter.role.id), leafs]) } else { .isReferenceOfRole(filter.role.id) }
//            //        guard expansions[item.id.uuidString] else { return [] }
//            //        return item.to.filter { fullcondition.matches($0, structure: structure) }
////            filter.allRoles
////                .filter { $0.conforms(to: filter.roles) != nil }
//        let items = item.filter.filter(items: item.item.to)
//            if let order = filter.order {
//                return items.sorted(by: { order.compare(lhs: $0.item, rhs: $1.item, structure: structure) })
//            } else {
//                return items
//            }
//        }
//
//        // MARK: Content
//
//        @ViewBuilder var label: some View {
//            FilterResultView.ItemView(item: item,  layout: .list)
//                .padding(2)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    item.isSelected.toggle()
//                }
//                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.accentColor, lineWidth: 2).hidden(!item.isSelected))
//        }
//
//        var body: some View {
//            Group {
//                if children.isEmpty {
//                    label
//                } else {
//                    DisclosureGroup(key: key, isExpanded: $expansions) {
//                        if expansions[key] {
//                            ForEach(children, id: \.item) { item in
//                                RowView(item: item, filter: filter, expansions: $expansions, level: level + 1)
//                            }
//                        }
//                    } label: {
//                        label
//                    }
//                }
//            }
//        }
//    }
//}
//

