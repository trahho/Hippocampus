//
//  PresentationEditView.ItemEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import Grisu
import SwiftUI

extension Array where Element == Presentation {
    mutating func remove(item: Element) {
        guard let index = firstIndex(of: item) else { return }
        remove(at: index)
    }

    mutating func insert(item: Element, after: Element) {
        guard let index = firstIndex(of: after) else { return }
        insert(item, at: index + 1)
    }
}

extension PresentationEditView {
    struct ItemEditView: View {
        @Environment(DragDropCache.self) var dragDropCache
        @Environment(Document.self) var document

        @Binding var presentation: Presentation
        @State var role: Structure.Role

        @Binding var array: [Presentation]
        @State var al: Presentation.Alignment = .leading

        var contextMenu: some View {
            ContextMenu(presentation: $presentation, array: $array)
        }

        var draggable: Presentation {
            array.remove(item: presentation)
            return presentation
        }

        func aspectName(id: Structure.Aspect.ID) -> String {
            guard let aspect = role.allAspects.first(where: { $0.id == id }) else { return "unknown" }
            return aspect.name
        }

        func aspect(id: Structure.Aspect.ID) -> Structure.Aspect? {
            guard let aspect = role.allAspects.first(where: { $0.id == id }) else { return nil }
            return aspect
        }

        var aspects: [Structure.Aspect] {
            role.allAspects.sorted { $0.name < $1.name }
        }

        var body: some View {
            Group {
                switch presentation {
                case .undefined:
                    Text("create")
                        .font(.footnote)
                        .contextMenu { contextMenu }
                case .label(let string):
                    HStack(alignment: .firstTextBaseline) {
                        TextField(text: Binding(get: { string }, set: { presentation = .label($0) }), prompt: Text("Required")) { EmptyView() }
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                    }
                    .frame(maxWidth: .infinity)
                    .contextMenu { contextMenu }
                    .draggable(draggable)
                    .dropDestination { items, _ in array.insert(item: items.first!, after: presentation); return true }
                case .aspect(let aspectId, let showAs):
                    HStack(alignment: .center) {
                        ValuePicker("", data: aspects, selection: Binding<Structure.Aspect?>(get: { aspect(id: aspectId) }, set: { aspect in
                            guard let aspect else { return }
                            presentation = .aspect(aspect.id, presentation: showAs)
                        }), unkown: "unknown")
                        Picker("", selection: Binding(get :{ showAs}, set: { presentation = .aspect(aspectId, presentation: $0)})){
                            ForEach( aspect(id: aspectId)?.presentation ?? []) { presentation in
                                Text("\(presentation)")
                                    .tag (presentation)
                            }
                        }
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                    }
                    .frame(maxWidth: .infinity)
                    .contextMenu { contextMenu }
                    .draggable(draggable)
                case .color(let children, color: let color):
                    VStack(alignment: .leading) {
                        ColorPicker("Foreground", selection: Binding(get: { color }, set: { presentation = .color(children, color: $0) }))
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in presentation = .color(items + children, color: color); return true }

                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .color($0, color: color) }), role: role)
                    }
                case .background(let children, color: let color):
                    VStack(alignment: .leading) {
                        ColorPicker("Background", selection: Binding(get: { color }, set: { presentation = .background(children, color: $0) }))
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in presentation = .background(items + children, color: color); return true }

                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .background($0, color: color) }), role: role)
                    }
                case .grouped(let children):
                    VStack(alignment: .leading) {
                        Text("Padded")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in presentation = .grouped(items + children); return true }

                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .grouped($0) }), role: role)
                    }
                case .vertical(let children, let alignment):
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            Text("Vertical")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .contextMenu { contextMenu }
                                .draggable(draggable)
                                .dropDestination { items, _ in presentation = .vertical(items + children, alignment: alignment); return true }

                            Picker("", selection: Binding(get: { alignment }, set: { presentation = .vertical(children, alignment: $0) })) {
                                Image(systemName: "align.horizontal.left")
                                    .tag(Presentation.Alignment.leading)
                                Image(systemName: "align.horizontal.center")
                                    .tag(Presentation.Alignment.center)
                                Image(systemName: "align.horizontal.right")
                                    .tag(Presentation.Alignment.trailing)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        VStack(alignment: alignment.horizontal) {
                            PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .vertical($0, alignment: alignment) }), role: role)
                        }
                    }
                case .horizontal(let children, let alignment):
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            Text("Horizontal")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .contextMenu { contextMenu }
                                .draggable(draggable)
                                .dropDestination { items, _ in presentation = .horizontal(items + children, alignment: alignment); return true }

                            Picker("", selection: Binding(get: { alignment }, set: { presentation = .horizontal(children, alignment: $0) })) {
                                Image(systemName: "align.vertical.top")
                                    .tag(Presentation.Alignment.leading)
                                Image(systemName: "align.vertical.center")
                                    .tag(Presentation.Alignment.center)
                                Image(systemName: "align.vertical.bottom")
                                    .tag(Presentation.Alignment.trailing)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        HStack(alignment: alignment.vertical) {
                            PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .horizontal($0, alignment: alignment) }), role: role)
                        }
                    }
                default:
                    EmptyView()
                }
            }

            .padding(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.primary, lineWidth: 1)
            }
            .id(UUID())
        }
    }
}

// #Preview {
//    @State var presentation: Presentation = .horizontal([
//        .label("Hallo"),
//        .label("Welt")
//    ], alignment: .center)
//
//    return PresentationEditView.ItemEditView(presentation: $presentation, array: .constant([]))
//        .environment(DragDropCache())
// }
