//
//  PresentationEditView.ItemEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import SwiftUI

extension PresentationEditView {
    struct ItemEditView: View {
        @Environment(DragDropCache.self) var dragDropCache: DragDropCache

        @Binding var presentation: Presentation
        @Binding var array: [Presentation]
        @State var index: Int = .min
        @State var al: Presentation.Alignment = .leading

        var body: some View {
            Group {
                switch presentation {
                case .label(let string):
                    HStack{
                        TextField("", text: Binding(get: { string }, set: { presentation = .label($0) }))
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .onDrag { dragDropCache.drag(presentation: presentation, source: $array, index: index) } preview: { Text("Source View") }
                    }
                    .frame(maxWidth: .infinity)
                        .contextMenu { ContextMenu(presentation: $presentation, array: $array, index: index) }
                case .undefined:
                    Text("create")
                        .font(.footnote)
                        .contextMenu { ContextMenu(presentation: $presentation, array: $array, index: index) }
                case .color(let children, color: let color):
                    DisclosureGroup(isExpanded: .constant(true)) {
                        PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .color($0, color: color) }))
                    } label: {
                        ColorPicker("Color", selection: Binding(get: { color }, set: { presentation = .color(children, color: $0) }))
                            .contextMenu { ContextMenu(presentation: $presentation, array: $array, index: index) }
                    }
                case .grouped(let children):
                    DisclosureGroup(isExpanded: .constant(true)) {
                        PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .grouped($0) }))
                    } label: {
                        Text("Grouped")
                            .contextMenu { ContextMenu(presentation: $presentation, array: $array, index: index) }
                    }
                case .background(let children, color: let color):
                    DisclosureGroup(isExpanded: .constant(true)) {
                        PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .background($0, color: color) }))
                    } label: {
                        ColorPicker("Background", selection: Binding(get: { color }, set: { presentation = .background(children, color: $0) }))
                            .contextMenu { ContextMenu(presentation: $presentation, array: $array, index: index) }
                    }
                case .vertical(let children, let alignment):
                    DisclosureGroup(isExpanded: .constant(true)) {
                        PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .vertical($0, alignment: alignment) }))
                    } label: {
                        HStack {
                            Text("Vertical")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .contextMenu { ContextMenu(presentation: $presentation, array: $array, index: index) }
                            Picker("", selection: Binding(get: { alignment }, set: { presentation = .vertical(children, alignment: $0) })) {
                                Image(systemName: "align.horizontal.left")
                                    .tag(Presentation.Alignment.leading)
                                Image(systemName: "align.horizontal.center")
                                    .tag(Presentation.Alignment.center)
                                Image(systemName: "align.horizontal.right")
                                    .tag(Presentation.Alignment.trailing)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(maxWidth: 100)
                        }
                    }
                case .horizontal(let children, let alignment):
                    DisclosureGroup(isExpanded: .constant(true)) {
                        PresentationsEditView(presentations: Binding(get: { children }, set: { presentation = .horizontal($0, alignment: alignment) }))
                    } label: {
                        HStack {
                            Text("Horizontal")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .contextMenu { ContextMenu(presentation: $presentation, array: $array, index: index) }
                            Picker("", selection: Binding(get: { alignment }, set: { presentation = .horizontal(children, alignment: $0) })) {
                                Image(systemName: "align.vertical.top")
                                    .tag(Presentation.Alignment.leading)
                                Image(systemName: "align.vertical.center")
                                    .tag(Presentation.Alignment.center)
                                Image(systemName: "align.vertical.bottom")
                                    .tag(Presentation.Alignment.trailing)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(maxWidth: 100)
                        }
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}
