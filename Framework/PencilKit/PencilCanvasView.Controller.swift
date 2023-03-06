//
//  PencilCanvasView.Controller.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Foundation
import PencilKit
import UIKit

extension PencilCanvasView {
    final class Controller: UIViewController, PKCanvasViewDelegate {
        lazy var drawingView: View = .init()
        lazy var toolPicker: PKToolPicker = .init()
        
        private let canvasSize = CGSize(width: 1_000_000, height: 1_000_000)
        
        var coordinator: Coordinator?
        
        // MARK: - - View setup
        
        override func loadView() {
            view = drawingView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            toolPicker.addObserver(drawingView.canvasView)
            drawingView.canvasView.delegate = self
            drawingView.canvasView.contentSize = canvasSize
            disableDrawing()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            enableDrawing()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            drawingView.gridView.frame = drawingView.canvasView.frame
            drawingView.gridView.setNeedsDisplay()
            if contentNeedsBeingCentered {
                centerDrawing()
            }
        }
        
        // MARK: - - Drawing
        
        var contentNeedsBeingCentered = true
        
        var drawing: PKDrawing {
            get { drawingView.canvasView.drawing }
            set {
                let currentValue = drawingView.canvasView.drawing
                if newValue.strokes.isEmpty, currentValue.strokes.isEmpty {
                    print("Drawing still empty")
                    contentNeedsBeingCentered = true
                } else if newValue != currentValue {
                    contentNeedsBeingCentered = currentValue.strokes.isEmpty
                    drawingView.canvasView.drawing = newValue
                    print("Drawing accepted")
                } else {
                    //                    print("Drawing ignored")
                }
            }
        }
        
        var center: CGPoint {
            get {
                let canvasView = drawingView.canvasView
                let offset = canvasView.contentOffset
                let viewBounds = canvasView.bounds
                let zoomScale = canvasView.zoomScale
                return CGPoint(x: (offset.x + viewBounds.width / 2) / zoomScale, y: (offset.y + viewBounds.height / 2) / zoomScale)
            }
            set {
                let canvasView = drawingView.canvasView
                let gridView = drawingView.gridView
                
                let viewBounds = canvasView.bounds
                let zoomScale = canvasView.zoomScale
                
                let offsetX = newValue.x * zoomScale - viewBounds.width / 2
                let offsetY = newValue.y * zoomScale - viewBounds.height / 2
                let offset = CGPoint(x: offsetX, y: offsetY)
                
                canvasView.contentOffset = offset
                gridView.offset = offset
                contentNeedsBeingCentered = false
            }
        }
        
        func centerDrawing() {
            let canvasView = drawingView.canvasView
            let drawing = canvasView.drawing
            if drawing.strokes.isEmpty {
                let contentSize = canvasView.contentSize
                center = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
            } else {
                center = CGPoint(x: drawing.bounds.midX, y: drawing.bounds.midY)
            }
        }
        
        // MARK: - - Activation
        
        private var drawingEnabled: Bool = false
        var isActive: Bool {
            get { drawingEnabled }
            set(newState) {
                if !drawingEnabled && newState == true {
                    enableDrawing()
                } else if drawingEnabled && newState == false {
                    disableDrawing()
                }
            }
        }
        
        private func enableDrawing() {
            guard !drawingEnabled else { return }
            let canvasView = drawingView.canvasView
            canvasView.drawingGestureRecognizer.isEnabled = true
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            if !canvasView.isFirstResponder { canvasView.becomeFirstResponder() }
            drawingEnabled = true
        }
        
        func disableDrawing() {
            guard drawingEnabled else { return }
            let canvasView = drawingView.canvasView
            canvasView.drawingGestureRecognizer.isEnabled = false
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            drawingEnabled = false
        }
        
        // MARK: - - Grid properties
        
        var background: Background {
            get { drawingView.gridView.mode }
            set {
                guard drawingView.gridView.mode != newValue else { return }
                drawingView.gridView.mode = newValue
            }
        }
        
        var pageFormat: PageFormat {
            get { drawingView.gridView.page }
            set {
                guard drawingView.gridView.page != newValue else { return }
                drawingView.gridView.page = newValue
            }
        }
        
        // MARK: - - PKCanvasDelegate
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            updatePositionIndicators()
            guard let coordinator else { return }
            coordinator.drawingDidChange(self, drawing: canvasView.drawing)
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            drawingView.gridView.zoomScale = scrollView.zoomScale
            notifyCenterHasChanged()
            updatePositionIndicators()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentNeedsBeingCentered = false
            drawingView.gridView.offset = scrollView.contentOffset
            notifyCenterHasChanged()
            updatePositionIndicators()
        }
        
        func notifyCenterHasChanged() {
            guard let coordinator else { return }
            coordinator.centerDidChange(self, center: center)
        }
        
        func updatePositionIndicators() {
            let drawingBounds = drawing.bounds
            let viewBounds = drawingView.bounds
            let canvasView = drawingView.canvasView
            
            guard !drawingBounds.isEmpty, !viewBounds.isEmpty else { return }
            let offset = canvasView.contentOffset
            
            let minWidth: CGFloat = 12
            let zoomScale = canvasView.zoomScale
            let zoomedDrawingBounds = CGRect(x: drawingBounds.minX * zoomScale, y: drawingBounds.minY * zoomScale, width: drawingBounds.width * zoomScale, height: drawingBounds.height * zoomScale)
            
            let horizontalLeading = viewBounds.minX - (zoomedDrawingBounds.minX - offset.x)
            let horizontalLeadingRatio = horizontalLeading / zoomedDrawingBounds.width
            let horizontalLeadingOffset = viewBounds.minX + viewBounds.width * horizontalLeadingRatio
            
            let horizontalTrailing = (zoomedDrawingBounds.maxX - offset.x) - viewBounds.maxX
            let horizontalTrailingRatio = horizontalTrailing / zoomedDrawingBounds.width
            let horizontalTrailingOffset = viewBounds.maxX - viewBounds.width * horizontalTrailingRatio
            
            drawingView.topHorizontalIndicatorView.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: viewBounds.width, height: minWidth)
            drawingView.topHorizontalIndicatorView.setThumb(start: horizontalLeadingOffset, end: horizontalTrailingOffset)
            
            let verticalLeading = viewBounds.minY - (zoomedDrawingBounds.minY - offset.y)
            let verticalLeadingRatio = verticalLeading / zoomedDrawingBounds.height
            let verticalLeadingOffset = viewBounds.minY + viewBounds.height * verticalLeadingRatio
            
            let verticalTrailing = (zoomedDrawingBounds.maxY - offset.y) - viewBounds.maxY
            let verticalTrailingRatio = verticalTrailing / zoomedDrawingBounds.height
            let verticalTrailingOffset = viewBounds.maxY - viewBounds.height * verticalTrailingRatio
            
            drawingView.leftVerticalIndicatorView.frame = CGRect(x: viewBounds.minX, y: viewBounds.minY, width: minWidth, height: viewBounds.height)
            drawingView.leftVerticalIndicatorView.setThumb(start: verticalLeadingOffset, end: verticalTrailingOffset)
            
            drawingView.gridView.setNeedsDisplay()
        }
        
        var scaledDrawingBounds: CGRect {
            let scale = drawingView.canvasView.zoomScale
            return CGRect(x: drawing.bounds.minX * scale, y: drawing.bounds.minY * scale, width: drawing.bounds.width * scale, height: drawing.bounds.height * scale)
        }
    }
}
