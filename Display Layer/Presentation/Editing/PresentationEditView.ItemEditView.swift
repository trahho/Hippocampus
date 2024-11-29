//
//  PresentationEditView.ItemEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import Grisu
import SwiftUI

extension PresentationEditView {
    struct ItemEditView: View {
        // MARK: Properties

//        @Environment(DragDropCache<Presentation>.self) var dragDropCache
        @Environment(\.document) var document

        @Binding var presentation: Presentation
        @State var perspective: Structure.Perspective? = nil

        @Binding var array: [Presentation]
        @State var al: Presentation.Alignment = .leading

        @State var text: String?

        // MARK: Computed Properties

        var draggable: Presentation {
            array.remove(item: presentation)
            return presentation
        }

        var aspects: [Structure.Aspect] {
            perspective?.allAspects.sorted { $0.name < $1.name } ?? []
        }

        var perspectives: [Structure.Perspective] {
            document.structure.perspectives.filter { $0 != Structure.Perspective.Statics.same }.sorted { $0.description < $1.description }
        }

        // MARK: Content

        var contextMenu: some View {
            ContextMenu(presentation: $presentation, array: $array)
        }

        var body: some View {
            Group {
                switch presentation {
                case .undefined:
                    Text("create")
                        .font(.footnote)
                        .contextMenu { contextMenu }
                case let .label(string):
                    HStack(alignment: .firstTextBaseline) {
                        TextField(text: Binding(get: { string }, set: { presentation = .label($0) }), prompt: Text("Required")) { EmptyView() }
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                    }
                    .frame(maxWidth: .infinity)
                    .contextMenu { contextMenu }
                    .draggable(draggable)
                    .dropDestination { items, _ in array.insert(item: items.first!, after: presentation); return true }
                case let .icon(string):
                    HStack(alignment: .firstTextBaseline) {
                        if !string.isEmpty {
                            Image(systemName: string)
                        } else {
                            Image(systemName: "")
                        }
                        TextField(text: Binding(get: { string }, set: { presentation = .icon($0) }), prompt: Text("SFSymbol")) { EmptyView() }
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                    }
                    .frame(maxWidth: .infinity)
                    .contextMenu { contextMenu }
                    .draggable(draggable)
                    .dropDestination { items, _ in array.insert(item: items.first!, after: presentation); return true }
//                    }
                case let .perspective(perspectiveId, layout, name):
                    HStack(alignment: .center) {
                        ValuePicker("", data: perspectives, selection: Binding<Structure.Perspective?>(get: { perspective(id: perspectiveId) }, set: { perspective in
                            guard let perspective else { return }
                            presentation = .perspective(perspective.id, layout: layout, name: name)
                        }), unkown: "unknown")
                            .sensitive
                        EnumPicker("Layout", selection: Binding<Presentation.Layout>(get: { layout }, set: { presentation = .perspective(perspectiveId, layout: $0, name: name) }))
                        TextField("Name", text: Binding(get: { name ?? "" }, set: { presentation = .perspective(perspectiveId, layout: layout, name: $0.isEmpty ? nil : $0) }))
                    }
                case let .aspect(aspectId, appearance):
                    HStack(alignment: .center) {
                        ValuePicker("", data: perspectives, selection: $perspective, unkown: "unknown")
                        ValuePicker("", data: aspects, selection: Binding<Structure.Aspect?>(get: { aspect(id: aspectId) }, set: { aspect in
                            guard let aspect else { return }
                            presentation = .aspect(aspect.id, appearance: appearance)
                        }), unkown: "unknown")
                            .sensitive
                        Picker("", selection: Binding(get: { appearance }, set: { presentation = .aspect(aspectId, appearance: $0) })) {
                            ForEach(aspect(id: aspectId)?.presentation ?? []) { presentation in
                                Text("\(presentation)")
                                    .tag(presentation)
                            }
                        }
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                    }
                    .onAppear {
                        perspective = aspect(id: aspectId)?.perspective
                    }
                    .frame(maxWidth: .infinity)
                    .contextMenu { contextMenu }
                    .draggable(draggable)
                case let .color(children, color: color):
                    VStack(alignment: .leading) {
                        ColorPicker("Foreground", selection: Binding(get: { color }, set: { presentation = .color(children, color: $0) }))
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in presentation = .color(items + children, color: color); return true }

                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .color($0, color: color) }))
                    }
                case let .background(children, color: color):
                    VStack(alignment: .leading) {
                        ColorPicker("Background", selection: Binding(get: { color }, set: { presentation = .background(children, color: $0) }))
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in presentation = .background(items + children, color: color); return true }

                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .background($0, color: color) }))
                    }
                case let .spaced(children, horizontal, vertical):
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            EnumPicker("Horizontal", selection: Binding(get: { horizontal }, set: { presentation = .spaced(children, horizontal: $0, vertical: vertical) }))
                                .contextMenu { contextMenu }
                                .draggable(draggable)
                                .dropDestination { items, _ in presentation = .spaced(items + children, horizontal: horizontal, vertical: vertical); return true }
//                            Spacer()
                            switch horizontal {
                            case let .full(alignment):
                                Picker("", selection: Binding(get: { alignment }, set: { presentation = .spaced(children, horizontal: .full(alignment: $0), vertical: vertical) })) {
                                    Image(systemName: "align.horizontal.left")
                                        .tag(Presentation.Alignment.leading)
                                    Image(systemName: "align.horizontal.center")
                                        .tag(Presentation.Alignment.center)
                                    Image(systemName: "align.horizontal.right")
                                        .tag(Presentation.Alignment.trailing)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            case .normal:
                                EmptyView()
                            case let .percent(percent, alignment):
                                TextField("%", text: Binding(get: {
                                    String(percent)
                                }, set: {
                                    guard let percent = Double($0) else { return }
                                    presentation = .spaced(children, horizontal: .percent(percent, alignment: alignment), vertical: vertical)
                                }))
                                Picker("", selection: Binding(get: { alignment }, set: { presentation = .spaced(children, horizontal: .percent(percent, alignment: $0), vertical: vertical) })) {
                                    Image(systemName: "align.horizontal.left")
                                        .tag(Presentation.Alignment.leading)
                                    Image(systemName: "align.horizontal.center")
                                        .tag(Presentation.Alignment.center)
                                    Image(systemName: "align.horizontal.right")
                                        .tag(Presentation.Alignment.trailing)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        VStack(alignment: .leading) {
                            EnumPicker("Vertical", selection: Binding(get: { vertical }, set: { presentation = .spaced(children, horizontal: horizontal, vertical: $0) }))
                                .contextMenu { contextMenu }
                                .draggable(draggable)
                                .dropDestination { items, _ in presentation = .spaced(items + children, horizontal: horizontal, vertical: vertical); return true }
//                            Spacer()
                            switch vertical {
                            case let .full(alignment):
                                Picker("", selection: Binding(get: { alignment }, set: { presentation = .spaced(children, horizontal: horizontal, vertical: .full(alignment: $0)) })) {
                                    Image(systemName: "align.vertical.top")
                                        .tag(Presentation.Alignment.leading)
                                    Image(systemName: "align.vertical.center")
                                        .tag(Presentation.Alignment.center)
                                    Image(systemName: "align.vertical.bottom")
                                        .tag(Presentation.Alignment.trailing)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            case .normal:
                                EmptyView()
                            case let .percent(percent, alignment):
                                TextField("%", text: Binding(get: {
                                    String(percent)
                                }, set: {
                                    guard let percent = Double($0) else { return }
                                    presentation = .spaced(children, horizontal: horizontal, vertical: .percent(percent, alignment: alignment))
                                }))
                                Picker("", selection: Binding(get: { alignment }, set: { presentation = .spaced(children, horizontal: horizontal, vertical: .percent(percent, alignment: $0)) })) {
                                    Image(systemName: "align.vertical.top")
                                        .tag(Presentation.Alignment.leading)
                                    Image(systemName: "align.vertical.center")
                                        .tag(Presentation.Alignment.center)
                                    Image(systemName: "align.vertical.bottom")
                                        .tag(Presentation.Alignment.trailing)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }

                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .spaced($0, horizontal: horizontal, vertical: horizontal) }))
                    }
                case let .grouped(children):
                    VStack(alignment: .leading) {
                        Text("Padded")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in presentation = .grouped(items + children); return true }

                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .grouped($0) }))
                    }
                case let .vertical(children, alignment):
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
                            PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .vertical($0, alignment: alignment) }))
                        }
                    }
                case let .horizontal(children, alignment):
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

//                        HStack(alignment: alignment.vertical) {
                        PresentationEditView.PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .horizontal($0, alignment: alignment) }))
//                        }
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
//            .id(UUID())
        }

        // MARK: Functions

        func perspective(id: Structure.Perspective.ID) -> Structure.Perspective? {
            guard let perspective = document[Structure.Perspective.self, id] else { return nil }
            return perspective
        }

        func aspectName(id: Structure.Aspect.ID) -> String {
            guard let aspect = aspect(id: id) else { return "unknown" }
            return aspect.name
        }

        func aspect(id: Structure.Aspect.ID) -> Structure.Aspect? {
            guard let aspect = document[Structure.Aspect.self, id] else { return nil }
            return aspect
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
