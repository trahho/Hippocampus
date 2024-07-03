////
////  PresentationView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 25.05.24.
////
//
//import SwiftUI
//
//struct ItemPresentationView: View {
//    @Environment(Structure.self) var structure
//    @Environment(Structure.Role.self) var role
//    @State var presentation: Presentation
//    @State var item: Information.Item
//    @State var layout: Presentation.Layout
//    @State var appearance: Presentation.Appearance
//
//    var body: some View {
//        switch presentation {
////        case .empty:
////            EmptyView()
////        case .undefined:
////            Image(systemName: "eye.trianglebadge.exclamationmark")
////        case .label(let string):
////            Text(string)
////        case .aspect(let id, let appearance, let editable):
//////            if let aspect = structure[Structure.Aspect.self, id] {
//////                AspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
//////            } else {
////                Image(systemName: "eye.trianglebadge.exclamationmark")
//////            }
////        case .horizontal(let elements, let alignment):
////            HorizontalLayoutView(item: item, elements: elements, alignment: alignment, layout: layout, appearance: appearance)
////        case .vertical(let elements, let alignment):
////            VerticalLayoutView(item: item, elements: elements, alignment: alignment, layout: layout, appearance: appearance)
////        case .sequence(let sequences, let layout):
////            if self.layout == .list {
////                DisclosureGroup {
////                    SequenceView(items: item.to, sequences: sequences, layout: layout, appearance: appearance)
////                } label: {
////                    ItemPresentationView(presentation: .present(role.id), item: item, layout: .list, appearance: .line)
////                }
////            } else {
////                SequenceView(items: item.to, sequences: sequences, layout: layout, appearance: appearance)
////            }
//////        case .reference(let sequence)
//////        case .exclosing(let content, let header):
//////            DisclosureGroup {
//////                ItemPresentationView(presentation: content, item: item, layout: layout, appearance: appearance)
//////                    .frame(maxWidth: .infinity, alignment: .leading)
//////            } label: {
//////                ItemPresentationView(presentation: header ?? .present(role.id), item: item, layout: layout, appearance: Presentation.Appearance.line)
//////            }
//////        case .indirect(let roles):
//////            EmptyView()
////        case .named(_, let presentation, _, _):
////            ItemPresentationView(presentation: presentation, item: item, layout: layout, appearance: appearance)
////        case .present(let roleId):
////            if let role = roleId == Structure.Role.same.id ? role : structure[Structure.Role.self, roleId] {
////                LayoutItemView(item: item, layout: layout, appearance: appearance)
////                    .environment(role)
////            } else {
////                Image(systemName: "eye.trianglebadge.exclamationmark")
////            }
//        default:
//            EmptyView()
//        }
//    }
//}
//
////#Preview {
////    let document = HippocampusApp.previewDocument()
////    let item = Information.Item()
////    let presentation =
//////        Presentation.vertical([
//////            .normal(.aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)),
//////            .normal(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false))
//////        ], alignment: .leading)
////
//////        Presentation.exclosing(Presentation.exclosing(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false))
////
////    item[String.self, Structure.Role.text.text] = "Hallo Welt🤩"
////    return ItemPresentationView(presentation: presentation, item: item, layout: .list, appearance: .normal)
////        .environment(document.structure)
////}
