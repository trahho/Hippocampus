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
    typealias PersistentDrawingPoperties = Structure.Aspect.Representation.DrawingView.PersistentData.Properties
    typealias PersistentDrawingDrawing = Structure.Aspect.Representation.DrawingView.PersistentData.Drawing

    typealias PersistentDrawing = Structure.Aspect.Representation.DrawingView.PersistentData

    @EnvironmentObject var document: Document
    var body: some View {
//        let dataUrl = document.url.appending(components: "drawing", "Test.properties")
//        let drawingUrl = document.url.appending(components: "drawing", "Test.drawing")
//        let content = PersistentDrawingPoperties()
//        let container = PersistentContainer(url: dataUrl, content: content, commitOnChange: true)
//        let drawing = PersistentDrawingDrawing()
//        let dataContainer = PersistentContainer(url: drawingUrl, content: drawing, commitOnChange: true)
//        PersistentDrawingContainerView(drawingPropertiesContainer: container, drawingDataContainer: dataContainer)
        let drawing = PersistentDrawing(url: document.url.appending(components: "drawing", "Test"))
        PersistentDrawingView(persistentDrawing: drawing)
    }

    struct PersistentDrawingView: View {
        @ObservedObject var persistentDrawing: PersistentDrawing

        var body: some View {
            PencilCanvasView(drawing: $persistentDrawing.drawing, center: $persistentDrawing.center, background: persistentDrawing.background, pageFormat: persistentDrawing.pageFormat)
        }

        func save() {}

        func merge() {}
    }
}
