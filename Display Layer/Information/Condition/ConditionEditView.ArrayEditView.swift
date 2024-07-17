//
//  ConditionEditView.ArrayEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.07.24.
//

import SwiftUI

extension ConditionEditView {
    struct ArrayEditView: View {
        @Binding var array: [Information.Condition]
       

        var body: some View {
            if array.isEmpty {
                Text("Add children")
            } else {
//                DisclosureGroup {
                ForEach(0 ..< array.count, id: \.self) { i in
                    ItemEditView(condition: $array[i], array: $array)
                        .draggable(draggable(index: i))
                }
//                .padding(.leading)
//                } label: {
//                    content()
//                }
                //                .dropDestination(for: String.self) { items, at in
                ////                    guard items.count == 1, items.first ?? "" == "$" else { return false }
                //                    dragDropCache.drop( target: $presentations, at: at)
                //                }
                //                .onInsert(of: [.plainText], perform: { index, items in
                //                    guard items.count == 1 else { return }
                //                    dragDropCache.insert(target: $presentations, at: index)
                //                })
            }
        }

        func draggable(index: Int) -> Information.Condition {
            let result = array[index]
            array.remove(at: index)
            return result
        }
    }
}
