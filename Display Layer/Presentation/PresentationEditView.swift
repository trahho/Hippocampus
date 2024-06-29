//
//  PresentationEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import SwiftUI

struct PresentationEditView: View {
    @State var role: Structure.Role
    @Binding var presentation: Presentation
    @State var dragDropCache = DragDropCache()

    var body: some View {
//        HStack {
//        Form {
//            List {
        ItemEditView(presentation: $presentation, role: role, array: .constant([]))
//            }
//        }
            .environment(dragDropCache)
//            }
            .formStyle(.grouped)
    }

//    struct HorizontalEditView: View {
//        @Binding var array: [Data]
//        var body: some View {
//            ForEach(0..<array.count, id: \.self) { i in
//                EditView(data: $array[i])
//                    .contextMenu {
//                        Button("remove") {
//                            array.remove(at: i)
//                        }
//                    }
//            }
//        }
//    }
}

#Preview {
    @State var document = HippocampusApp.editStaticRolesDocument
    @State var presentation = Structure.Role.hierarchical.representations.first!.presentation
    @State var item = document(Information.Item.self)
    return VStack {
        PresentationEditView(role: .hierarchical, presentation: $presentation)
        PresentationView(presentation: presentation, item: item)
    }
}
