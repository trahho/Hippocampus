//
//  Structure.Aspect.DrawingView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.02.23.
//

import Combine
import Foundation
import PencilKit
import SwiftUI

extension Structure.Aspect.Representation {
    struct DrawingView: View {
        @ObservedObject var item: Information.Item
        @EnvironmentObject var document: Document

        var aspect: Structure.Aspect
        var editable: Bool

//        init(item: Information.Item, aspect: Structure.Aspect, editable: Bool) {
//            self.item = item
//            self.aspect = aspect
//            self.editable = editable
//            let dataUrl = document.url.appending(components: "drawing", "\(item.id)--\(aspect.id).persistentdrawing")
//            self.data = PersistentContainer(url: dataUrl, content: PersistentDrawing())
//        }

        var body: some View {
            let dataUrl = document.url.appending(components: "drawing", "\(item.id)--\(aspect.id).persistentdrawing")
            let data = PersistentContainer(url: dataUrl, content: PersistentDrawingProperties())
            CanvasHostView(data: data, editable: editable)
        }

        struct CanvasHostView: View {
            @ObservedObject var data: PersistentContainer<PersistentDrawingProperties>

            var editable: Bool

            var body: some View {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 100, height: 100)
            }
        }

        class PersistentDrawing: ObservableObject {
            @Observed private var drawingContainer: PersistentContainer<PersistentDrawingDrawing>
            @Observed private var propertiesContainer: PersistentContainer<PersistentDrawingProperties>

            var drawing: PersistentDrawingDrawing { drawingContainer.content }

            var properties: PersistentDrawingProperties { propertiesContainer.content }
        }

        class PersistentDrawingDrawing: PersistentContent, ObservableObject {
            private var isMerging = false

            var objectDidChange = PassthroughSubject<Void, Never>()

            var drawing: PKDrawing = .init() {
                willSet {
                    objectWillChange.send()
                }
                didSet {
                    guard !isMerging else { return }
                    objectDidChange.send()
                }
            }

            func restore() {}

            func merge(other: Structure.Aspect.Representation.DrawingView.PersistentDrawingDrawing) throws {
                isMerging = true
                drawing = other.drawing
                isMerging = false
            }

            func encode() -> Data? {
                drawing.dataRepresentation()
            }

            static func decode(persistentData: Data) -> Self? {
                guard let drawing = try? PKDrawing(data: persistentData) else { return nil }
                return (PersistentDrawingDrawing(drawing: drawing) as! Self)
            }

            private init(drawing: PKDrawing) {
                self.drawing = drawing
            }

            init() {}
        }

        class PersistentDrawingProperties: PersistentContent, Serializable, ObservableObject {
            @Serialized("center") private var _center: CGPoint = .zero

            var center: CGPoint {
                get { _center }
                set {
                    objectWillChange.send()
                    _center = newValue
                    objectDidChange.send()
                }
            }

            @Serialized private var _pageFormat: PencilCanvasView.PageFormat = .A4

            var pageFormat: PencilCanvasView.PageFormat {
                get { _pageFormat }
                set {
                    objectWillChange.send()
                    _pageFormat = newValue
                    objectDidChange.send()
                }
            }

            @Serialized private var _background: PencilCanvasView.Background = .shorthandGrid

            var background: PencilCanvasView.Background {
                get { _background }
                set {
                    objectWillChange.send()
                    _background = newValue
                    objectDidChange.send()
                }
            }

            // MARK: - Publishers

            var objectDidChange = PassthroughSubject<Void, Never>()

            // MARK: - Initialisation

            public required init() {}

            // MARK: - Merging

            func merge(other: PersistentDrawingProperties) throws {
                objectWillChange.send()
                center = other.center
                pageFormat = other.pageFormat
                background = other.background
            }

            func restore() {}
        }
    }
}
