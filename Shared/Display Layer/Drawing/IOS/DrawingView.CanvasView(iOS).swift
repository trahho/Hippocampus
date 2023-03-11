//
//  DrawingView.CanvasView(iOS).swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation
import SwiftUI

struct CanvasView: View {
    @ObservedObject var data: Document.Drawing
        
    var editable: Bool
        
    var body: some View {
        PencilCanvasView(drawing: $data.drawing, center: $data.center, background: data.background, pageFormat: data.pageFormat)
    }
}
