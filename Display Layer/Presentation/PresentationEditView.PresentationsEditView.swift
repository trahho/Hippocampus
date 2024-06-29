//
//  PresentationEditView.ArrayEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import SwiftUI

class DragDropCache: Observable {
//    func performDrop(info: DropInfo) -> Bool {
//        guard let source, let index, let presentation else { return false }
//        return true
//    }

    let id = UUID()

    struct CacheItem {
        let source: Binding<[Presentation]>
        let index: Int
        let presentation: Presentation
    }

//    var cache: [Presentation: CacheItem] = [:]
    var cache: CacheItem?

    func drag(presentation: Presentation, source: Binding<[Presentation]>, index: Int) -> Presentation {
        cache = CacheItem(source: source, index: index, presentation: presentation)
        print("Dragging \(presentation)")
        source.wrappedValue.remove(at: index)
        return presentation
    }

    func drop(presentation: Presentation, target: Binding<[Presentation]>, at: Int) -> Bool {
        guard let cache else { return false }
        print("Dropping \(presentation)")

//        print("\(cache.source.wrappedValue.count) -> \(target.wrappedValue.count) ")
//        cache.source.wrappedValue.remove(at: cache.index)
//        print("\(cache.source.wrappedValue.count) -> \(target.wrappedValue.count) ")

        target.wrappedValue.insert(presentation, at: at)
//        print("\(cache.source.wrappedValue.count) -> \(target.wrappedValue.count) ")

        self.cache = nil
        return true
    }
}

extension PresentationEditView {
    struct PresentationsEditView: View {
        @Environment(DragDropCache.self) var dragDropCache: DragDropCache
       
        @Binding var presentations: [Presentation]
        @State var role: Structure.Role

        var body: some View {
            if presentations.isEmpty {
                Text("Add children")
            } else {
                ForEach(0 ..< presentations.count, id: \.self) { i in
                    ItemEditView(presentation: $presentations[i], role: role, array: $presentations)
                        .draggable(dragDropCache.drag(presentation: presentations[i], source: $presentations, index: i))
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
    }
}
