//
//  PencilCanvasView.Coordinator.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Foundation
import SwiftUI
import PencilKit

extension PencilCanvasView {
    final class Coordinator: NSObject {
        var isBlocked = true
        var isSending = false
        var view: PencilCanvasView

        func drawingDidChange(_ controller: Controller, drawing: PKDrawing) {
            guard !isBlocked else { return }
            isSending = true
//            print("Drawing Controller -> View")
            view.drawing = drawing
            isSending = false
        }

        func centerDidChange(_ controller: Controller, center: CGPoint) {
            guard !isBlocked else { return }
            isSending = true
//            print("Center Controller -> View")
            view.center = center
            isSending = false
        }

        init(_ view: PencilCanvasView) {
            self.view = view
        }
    }
}
