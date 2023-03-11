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

struct DrawingView: View {
    @ObservedObject var item: Information.Item
    @EnvironmentObject var document: Document
        
    var aspect: Structure.Aspect
    var form: Form
    var editable: Bool
    
    var body: some View {
        switch form {
        case .icon:
            Image(systemName: "square.and.pencil")
        case .normal:
            DrawingCanvasView(data: document.getDrawing(item: item, aspect: aspect), editable: editable)
        case .small:
            DrawingImageView(data: document.getDrawing(item: item, aspect: aspect))
        }
    }
        
    struct DrawingCanvasView: View {
        @ObservedObject var data: Document.Drawing
            
        var editable: Bool
            
        var body: some View {
            PencilCanvasView(drawing: $data.drawing, center: $data.center, background: data.background, pageFormat: data.pageFormat)
        }
    }
            
    struct DrawingImageView: View {
        @ObservedObject var data: Document.Drawing
                
        var drawingImage: UIImage {
//                let bounds = data.drawing.strokes.reduce(CGRect(x: CGFloat.infinity, y: CGFloat.infinity, width: 0, height: 0)) { partialResult, stroke in
//                    let strokeBounds = stroke.renderBounds
//                    let minX = min(strokeBounds.minX, partialResult.minX)
//                    let minY = min(strokeBounds.minY, partialResult.minY)
//                    let maxX = max(strokeBounds.maxX, partialResult.maxX)
//                    let maxY = max(strokeBounds.maxY, partialResult.maxY)
//                    return CGRect(firstPoint: CGPoint(x: minX, y: minY), secondPoint: CGPoint(x: maxX, y: maxY))
//                }
//                let drawingBounds = data.drawing.bounds
            return data.drawing.image(from: data.drawing.bounds, scale: 1)
        }
                
        var body: some View {
            Image(uiImage: drawingImage)
//                    .resizable()
//                    .scaledToFit()
                .background(.blue)
                .scaleEffect(0.25)
        }
    }
}
