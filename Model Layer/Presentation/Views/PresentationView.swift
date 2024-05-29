//
//  PresentationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import SwiftUI

struct ItemPresentationView: View {
    @Environment(Structure.self) var structure
    @State var presentation: Presentation
    @State var item: Information.Item

    var body: some View {
        switch presentation {
        case .empty:
            EmptyView()
        case .undefined:
            Image(systemName: "eye.trianglebadge.exclamationmark")
        case .label(let string):
            Text(string)
        case .aspect(let id, let appearance, let editable):
            if let aspect = structure[Structure.Aspect.self, id] {
                AspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
            } else {
                Image(systemName: "eye.trianglebadge.exclamationmark")
            }
        case .horizontal(let elements, let alignment):
            HorizontalLayoutView(item: item, elements: elements, alignment: alignment)
        case .vertical(let elements, let alignment):
            VerticalLayoutView(item: item, elements: elements, alignment: alignment)
        case .sequence(let sequences, let layout):
            SequenceView(items: item.to, sequences: sequences, layout: layout)
        case .exclosing(let content, let header):
            DisclosureGroup {
                ItemPresentationView(presentation: content, item: item)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } label: {
                ItemPresentationView(presentation: header, item: item)
            }
        case .indirect(let roles):
            EmptyView()
//        case .named(_, let presentation):
//            ItemPresentationView(presentation: presentation, item: item)
        default:
            EmptyView()
        }
    }
}

 #Preview {
    let document = HippocampusApp.previewDocument()
    let item = Information.Item()
    let presentation =
//        Presentation.vertical([
//            .normal(.aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)),
//            .normal(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false))
//        ], alignment: .leading)

        Presentation.exclosing(Presentation.exclosing(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false))

    item[String.self, Structure.Role.text.text] = "Hallo Welt🤩"
    return ItemPresentationView(presentation: presentation, item: item)
        .environment(document.structure)
 }
