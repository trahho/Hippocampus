//
//  DrawingView.ImageView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation
import SwiftUI
import AppKit

extension DrawingView {
    struct ImageView: View {
        @ObservedObject var data: Document.Drawing
        
        var scale: CGFloat = 1

        var drawingImage: NSImage {
            return data.drawing.image(from: data.drawing.bounds, scale: 1)
                
        }

        var body: some View {
            if let image = drawingImage.scale(factor: scale) {
                Image(nsImage: image)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
            }
        }
    }
}
