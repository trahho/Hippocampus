//
//  Structure.Aspect.Representation.DrawingView.PersistentData.Drawing.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Combine
import Foundation
import PencilKit

extension Document.Drawing {
    class Drawing: PersistentContent, ObservableObject {
        
        private var isMerging = false

        var objectDidChange = Combine.ObservableObjectPublisher()

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

        func merge(other: Drawing) throws {
            isMerging = true
            drawing = other.drawing
            isMerging = false
        }

        func encode() -> Data? {
            drawing.dataRepresentation()
        }

        static func decode(persistentData: Data) -> Self? {
            guard let drawing = try? PKDrawing(data: persistentData) else { return nil }
            return (Drawing(drawing: drawing) as! Self)
        }

        private init(drawing: PKDrawing) {
            self.drawing = drawing
        }

        init() {}
    }
}
