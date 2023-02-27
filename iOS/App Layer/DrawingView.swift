//
//  DrawingView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 24.02.23.
//

import Foundation
import PencilKit
import SwiftUI

struct DrawingView: View {
    typealias PersistentDrawing = Structure.Aspect.Representation.DrawingView.PersistentDrawing
    
    @EnvironmentObject var document: Document
    var body: some View {
        let dataUrl = document.url.appending(components: "drawing", "Test.persistentdrawing")
        let drawingUrl = document.url.appending(components: "drawing", "Test.drawing")
        let content = PersistentDrawing()
        let container = PersistentContainer(url: dataUrl, content: content, commitOnChange: true)
        let drawing = PKDrawing()
        let dataContainer = PersistentDataContainer(url: drawingUrl, data: drawing.dataRepresentation())
        PersistentDrawingContainerView(persistentDrawingContainer: container, persistentDataContainer: dataContainer)
    }
    
    struct PersistentDrawingContainerView: View {
        @ObservedObject var persistentDrawingContainer: PersistentContainer<PersistentDrawing>
        @ObservedObject var persistentDataContainer: PersistentDataContainer

        var body: some View {
            PersistentDrawingView(content: persistentDrawingContainer.content, drawing: persistentDataContainer)
        }
    }
    
    struct PersistentDrawingView: View {
        @ObservedObject var content: PersistentDrawing
        @ObservedObject var drawing: PersistentDataContainer
        
        var drawingBinding: Binding<PKDrawing> {
            Binding(get: { try! PKDrawing(data: drawing.data) }, set: { drawing.data = $0.dataRepresentation(); drawing.save() })
        }
        
        var center: Binding<CGPoint> {
            Binding(get: { content.center }, set: { content.center = $0; content.objectDidChange.send() })
        }
        
        var body: some View {
            PencilCanvasView(drawing: drawingBinding, center: center, background: content.background, format: content.pageFormat)
        }
    }
}
