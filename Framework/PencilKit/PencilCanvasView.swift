//
//  PencilCanvasView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.02.23.
//

import Foundation
import PencilKit
import SwiftUI

struct PencilCanvasView: UIViewControllerRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var center: CGPoint
    @State var background: Background
    @State var pageFormat: PageFormat

    func makeUIViewController(context: Context) -> Controller {
        let controller = Controller()
        controller.coordinator = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: Controller, context: Context) {
        guard !context.coordinator.isSending else { return }
        context.coordinator.isBlocked = true
        
        print("Drawing View -> Controller")
        controller.drawing = drawing
        if center != .zero {
            print("Center View -> Controller")
            controller.center = center
        }
        print("PageFormat View -> Controller")
        controller.pageFormat = pageFormat
        print("Background View -> Controller")
        controller.background = background
        
        context.coordinator.isBlocked = false
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

//    final class OldViewController: UIViewController, PKCanvasViewDelegate {
//
//
//
//
//        func _centerContent() {
//            let contentSize = contentView.canvasView.contentSize
//            let viewSize = contentView.canvasView.bounds
//
//            guard !viewSize.isEmpty else { return }
//
//            let centerX = (contentSize.width - viewSize.width) / 2
//            let centerY = (contentSize.height - viewSize.height) / 2
//
//            contentView.canvasView.contentOffset = CGPoint(x: centerX, y: centerY)
//            contentView.gridView.offset = contentView.canvasView.contentOffset
//            contentView.gridView.zoomScale = contentView.canvasView.zoomScale
//            contentNeedsBeingCentered = false
//            print("Content centered")
//        }
//
//        func showFullDrawing() {
//            let canvasView = contentView.canvasView
//            let gridView = contentView.gridView
//
//            let drawing = canvasView.drawing
//            let drawingBounds = drawing.bounds
//
//            guard !drawingBounds.isEmpty else { return }
//
//            let drawingSize = drawingBounds.size
//            let viewSize = canvasView.bounds.size
//
//            let widthScale = viewSize.width / drawingSize.width
//            let heightScale = viewSize.height / drawingSize.height
//            let scale = min(min(widthScale, heightScale), 1)
//
//            let scaledOffset = CGPoint(
//                x: drawingBounds.minX * scale + (drawingSize.width * scale - viewSize.width) / 2,
//                y: drawingBounds.minY * scale + (drawingSize.height * scale - viewSize.height) / 2
//            )
//
//            canvasView.minimumZoomScale = min(canvasView.minimumZoomScale, scale)
//            canvasView.zoomScale = scale
//            gridView.zoomScale = scale
//            canvasView.contentOffset = scaledOffset
//            gridView.offset = scaledOffset
//        }
//
//        func resetZoom() {
//            contentView.canvasView.zoomScale = 1
//            contentView.gridView.zoomScale = 1
//        }
//
//
//
//        func moveToEdge(horizontal: Int, vertical: Int) {
//            let canvasView = contentView.canvasView
//            let gridView = contentView.gridView
//
//            guard !scaledDrawingBounds.isEmpty else { return }
//
//            let viewSize = canvasView.bounds.size
//
//            let scaledOffsetX: CGFloat
//            let scaledOffsetY: CGFloat
//
//            switch horizontal {
//            case 0:
//                scaledOffsetX = scaledDrawingBounds.minX - viewSize.width * 0.05
//            case 1:
//                scaledOffsetX = scaledDrawingBounds.minX + (scaledDrawingBounds.size.width - viewSize.width) / 2
//            case 2:
//                scaledOffsetX = scaledDrawingBounds.minX + (scaledDrawingBounds.size.width - viewSize.width) + viewSize.width * 0.05
//            default:
//                return
//            }
//
//            switch vertical {
//            case 0:
//                scaledOffsetY = scaledDrawingBounds.minY - viewSize.height * 0.05
//            case 1:
//                scaledOffsetY = scaledDrawingBounds.minY + (scaledDrawingBounds.size.height - viewSize.height) / 2
//            case 2:
//                scaledOffsetY = scaledDrawingBounds.minY + (scaledDrawingBounds.size.height - viewSize.height) + viewSize.height * 0.05
//            default:
//                return
//            }
//
//            let scaledOffset = CGPoint(x: scaledOffsetX, y: scaledOffsetY)
//
//            canvasView.contentOffset = scaledOffset
//            gridView.offset = scaledOffset
//        }
//
//
//    }
