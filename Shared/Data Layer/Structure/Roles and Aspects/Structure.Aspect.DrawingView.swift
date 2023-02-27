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
            let data = PersistentContainer(url: dataUrl, content: PersistentDrawing())
            CanvasHostView(data: data, editable: editable)
        }

        struct CanvasHostView: View {
            @ObservedObject var data: PersistentContainer<PersistentDrawing>

            var editable: Bool

            var body: some View {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 100, height: 100)
            }
        }

        class PersistentDrawing: PersistentContent, ObservableObject {
            var data: Data = .init()
            
            private var _drawing: PKDrawing?
            
            var drawing: PKDrawing {
                get {
                    guard let _drawing else {
                        if let drawing = try? PKDrawing(data: data) {
                            _drawing = drawing
                        } else {
                            _drawing = PKDrawing()
                        }
                        return _drawing!
                    }
                    return _drawing
                }
                set {
                    _drawing = newValue
                    data = newValue.dataRepresentation()
                }
            }

            @Published var center: CGPoint = .zero
            @Published var pageFormat: PencilCanvasView.PageFormat = .A4
            @Published var background: PencilCanvasView.Background = .shorthandGrid

            // MARK: - Publishers

            var objectDidChange = PassthroughSubject<Void, Never>()

            // MARK: - Initialisation

            public required init() {}

            // MARK: - Merging

            func merge(other: PersistentDrawing) throws {
                self.objectWillChange.send()
                data = other.data
                _drawing = nil
                center = other.center
                pageFormat = other.pageFormat
                background = other.background
            }

            func restore() {}

            enum CodingKeys: String, CodingKey {
                case drawing, center, pageFormat, background
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try! container.encode(data, forKey: .drawing)
                try container.encode(center, forKey: .center)
                try container.encode(pageFormat, forKey: .pageFormat)
                try container.encode(background, forKey: .background)
            }

            required init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decode(Data.self, forKey: .drawing)
                center = try values.decode(CGPoint.self, forKey: .center)
                pageFormat = try values.decode(PencilCanvasView.PageFormat.self, forKey: .pageFormat)
                background = try values.decode(PencilCanvasView.Background.self, forKey: .background)
            }
        }
    }
}
