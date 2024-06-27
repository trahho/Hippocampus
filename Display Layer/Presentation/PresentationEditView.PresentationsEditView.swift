//
//  PresentationEditView.ArrayEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import SwiftUI

class DragDropCache: Observable, DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        guard let source, let index, let presentation else { return false }
        return true
    }

    let id = UUID()

    private var source: Binding<[Presentation]>?
    private var index: Int?
    private var presentation: Presentation?

    func drag(presentation: Presentation, source: Binding<[Presentation]>, index: Int) -> NSItemProvider {
        self.presentation = presentation
        self.index = index
        self.source = source
        return NSItemProvider()
    }

    func insert(target: Binding<[Presentation]>, at: Int) {
        guard let source, let index, let presentation else { return }
        target.wrappedValue.insert(presentation, at: at)
        source.wrappedValue.remove(at: index)
    }
}

extension PresentationEditView {
    struct PresentationsEditView: View {
        @Environment(DragDropCache.self) var dragDropCache: DragDropCache
        @Binding var presentations: [Presentation]

        var body: some View {
            if presentations.isEmpty {
                Text("Add children")
            } else {
                ForEach(0 ..< presentations.count, id: \.self) { i in
                    ItemEditView(presentation: $presentations[i], array: $presentations, index: i)
                }
                .onInsert(of: [.plainText], perform: { index, items in
                    guard items.count == 1 else { return }
                    dragDropCache.insert(target: $presentations, at: index)
                })
            }
        }
    }
}
