//
//  ConditionEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.07.24.
//

import Grisu
import SwiftUI

struct ConditionEditView: View {
    struct ItemEditView: View {
        @Environment(Structure.self) var structure
        @Binding var condition: Information.Condition
        @Binding var array: [Information.Condition]

        var roles: [Structure.Role] {
            structure.roles.sorted { $0.description < $1.description }
        }

        var body: some View {
            Group {
                switch condition {
                case .nil:
                    Text("No condition")
                case .always(let bool):
                    Toggle("\(bool)", isOn: Binding(get: { bool }, set: { condition = .always($0) }))
                        .toggleStyle(.button)
                case .role(let roleId):
                    ValuePicker("", data: roles, selection: Binding<Structure.Role?>(get: { role(id: roleId) }, set: { role in
                        guard let role else { return }
                        condition = .role(role.id)
                    }), unkown: "unknown")
                    //            case .hasParticle(let iD, let condition):
                    //                <#code#>
                    //            case .isParticle(let iD):
                    //                <#code#>
                    //            case .isReferenced(let condition):
                    //                <#code#>
                    //            case .isReferenceOfRole(let iD):
                    //                <#code#>
                    //            case .hasReference(let condition):
                    //                <#code#>
                    //            case .hasValue(let comparison):
                    //                <#code#>
                    //            case .not(let condition):
                    //                <#code#>
                    //            case .any(let array):
                    //                <#code#>
                    //            case .all(let array):
                    //                <#code#>
                default:
                    EmptyView()
                }
            }
            .id(UUID())
        }

        func role(id: Structure.Role.ID) -> Structure.Role? {
            guard let role = structure[Structure.Role.self, id] else { return nil }
            return role
        }
    }

    struct ArrayEditView: View {
        @Binding var array: [Information.Condition]

        var body: some View {
            if array.isEmpty {
                Text("Add children")
            } else {
                ForEach(0 ..< array.count, id: \.self) { i in
                    ItemEditView(condition: $array[i], array: $array)
                        .draggable(draggable(index: i))
                }
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

    @Binding var condition: Information.Condition

    var body: some View {
        ItemEditView(condition: $condition, array: .constant([]))
            .formStyle(.grouped)
    }
}

#Preview {
    @Previewable @State var condition: Information.Condition = .role(Structure.Role.drawing.id)
    ConditionEditView(condition: $condition)
        .setDocument(HippocampusApp.previewDocument)
//        .environment(\.document, HippocampusApp.previewDocument)
}
