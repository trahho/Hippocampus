//
//  PresentationEditView.ArrayEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import SwiftUI

// class DragDropCache<Content>: Observable where Content: Transferable {
//    struct CacheItem {
//        let source: Binding<[Content]>
//        let index: Int
//        let content: Content
//    }
//
////    func performDrop(info: DropInfo) -> Bool {
////        guard let source, let index, let presentation else { return false }
////        return true
////    }
//
//    let id = UUID()
//
////    var cache: [Presentation: CacheItem] = [:]
//    var cache: CacheItem?
//
//    func drag(content: Content, source: Binding<[Content]>, index: Int) -> Content {
////        cache = CacheItem(source: source, index: index, content: content)
//        source.wrappedValue.remove(at: index)
//        return content
//    }
//
//    func drop(content: Content, target: Binding<[Content]>, at: Int) -> Bool {
////        guard let cache else { return false }
//
//        target.wrappedValue.insert(content, at: at)
//
//        self.cache = nil
//        return true
//    }
// }

extension PresentationEditView {
    struct PresentationsEditView: View {
        // MARK: Properties

//        @Environment(DragDropCache.self) var dragDropCache: DragDropCache

        @Binding var presentations: [Presentation]

        // MARK: Content

        var body: some View {
            if presentations.isEmpty {
                Text("Add children")
            } else {
                ForEach(0 ..< presentations.count, id: \.self) { i in
                    ItemEditView(presentation: self.$presentations[i], array: self.$presentations)
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

        // MARK: Functions

        func draggable(index: Int) -> Presentation {
            let result = presentations[index]
            presentations.remove(at: index)
            return result
        }
    }
}
