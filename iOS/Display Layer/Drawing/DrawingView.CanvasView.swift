////
////  DrawingView.CanvasView(iOS).swift
////  Hippocampus
////
////  Created by Guido Kühn on 11.03.23.
////
//
//import Foundation
//import SwiftUI
//
//extension DrawingView {
//    struct CanvasView: View {
//        @ObservedObject var data: Document.Drawing
//
//        var editable: Bool
//
//        var body: some View {
//            PencilCanvasView(drawing: $data.drawing.drawing, center: $data.properties.center, background: data.properties.background, pageFormat: data.properties.pageFormat)
//        }
//    }
//}
