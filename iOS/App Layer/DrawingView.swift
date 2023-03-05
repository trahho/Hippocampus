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
    typealias PersistentDrawingPoperties = Structure.Aspect.Representation.DrawingView.PersistentDrawingProperties
    typealias PersistentDrawingDrawing = Structure.Aspect.Representation.DrawingView.PersistentDrawingDrawing

    @EnvironmentObject var document: Document
    var body: some View {
        let dataUrl = document.url.appending(components: "drawing", "Test.properties")
        let drawingUrl = document.url.appending(components: "drawing", "Test.drawing")
        let content = PersistentDrawingPoperties()
        let container = PersistentContainer(url: dataUrl, content: content, commitOnChange: true)
        let drawing = PersistentDrawingDrawing()
        let dataContainer = PersistentContainer(url: drawingUrl, content: drawing, commitOnChange: true)
        PersistentDrawingContainerView(drawingPropertiesContainer: container, drawingDataContainer: dataContainer)
    }
    
    struct PersistentDrawingContainerView: View {
        @ObservedObject var drawingPropertiesContainer: PersistentContainer<PersistentDrawingPoperties>
        @ObservedObject var drawingDataContainer: PersistentContainer<PersistentDrawingDrawing>

        var body: some View {
            PersistentDrawingView(drawingDataContainer: drawingDataContainer, drawingPropertiesContainer: drawingPropertiesContainer)
        }
    }
    
    struct PersistentDrawingView: View {
//        @ObservedObject var content: PersistentDrawing
        @ObservedObject var drawingDataContainer: PersistentContainer<PersistentDrawingDrawing>
        @ObservedObject var drawingPropertiesContainer: PersistentContainer<PersistentDrawingPoperties>
        
//        var drawingBinding: Binding<PKDrawing> {
//            Binding(get: { try! PKDrawing(data: drawingDataContainer.data) },
//                    set: { drawingDataContainer.data = $0.dataRepresentation() })
//        }
//
        var body: some View {
            PencilCanvasView(drawing: $drawingDataContainer.content.drawing, center: $drawingPropertiesContainer.content.center, background: drawingPropertiesContainer.content.background, pageFormat: drawingPropertiesContainer.content.pageFormat)
        }
        
        func save() {}
        
        func merge() {}
    }
}
