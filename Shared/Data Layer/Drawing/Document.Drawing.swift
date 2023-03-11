//
//  Structure.Aspect.DrawingView.PersistentData.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Foundation
import PencilKit
import Combine

extension Document {
    class Drawing: ObservableObject {
        @Observed private var drawingContainer: PersistentContainer<Drawing>
        @Observed private var propertiesContainer: PersistentContainer<Properties>
        
        var drawing: PKDrawing {
            get { drawingContainer.content.drawing }
            set {
                drawingContainer.content.drawing = newValue
            }
        }
        
        var center: CGPoint {
            get { propertiesContainer.content.center }
            set { propertiesContainer.content.center = newValue }
        }
        
        var background: PencilCanvasView.Background {
            get { propertiesContainer.content.background }
            set {
                propertiesContainer.content.background = newValue
            }
        }
        
        var pageFormat: PencilCanvasView.PageFormat {
            get { propertiesContainer.content.pageFormat }
            set {
                propertiesContainer.content.pageFormat = newValue
            }
        }
        
        init(document: Document, name: String) {
            let url = document.url.appending(components: "drawings", name)
//            objectWillChange.handleEvents()
            drawingContainer = PersistentContainer(url: url.appending(component: "drawing"), content: Drawing(), commitOnChange: true)
            propertiesContainer = PersistentContainer(url: url.appending(component: "properties"), content: Properties(), commitOnChange: false)
            drawingContainer.dependentContainers.append(propertiesContainer)
        }
    }
}
