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

extension Structure.Aspect.Presentation {
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
                let data = Document.Drawing(document: document, name: "\(item.id)--\(aspect.id)")
                DrawingCanvasView(data: data, editable: editable)
            case .small:
                let data = Document.Drawing(document: document, name: "\(item.id)--\(aspect.id)")
                DrawingImageView(data: data)
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
                data.drawing.image(from: data.drawing.bounds, scale: 1)
            }
                
            var body: some View {
                Image(uiImage: drawingImage)
                    .scaleEffect(0.5)
            }
        }
    }
}
