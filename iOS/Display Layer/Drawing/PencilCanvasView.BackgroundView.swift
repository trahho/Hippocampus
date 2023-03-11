//
//  PencilCanvasView.BackgroundView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.02.23.
//

import Foundation
import PencilKit
import UIKit

extension PencilCanvasView {
    class BackgroundView: UIView {
        var zoomScale: CGFloat = 1 {
            didSet {
                setNeedsDisplay()
            }
        }
        
        var offset: CGPoint = .zero {
            didSet {
                setNeedsDisplay()
            }
        }
        
        var mode: Background = .squares {
            didSet {
                setNeedsDisplay()
            }
        }
        
        var page: PageFormat = .A4
        var canvas: PKCanvasView!
        
        //    var lineDistance: CGFloat = 20
        //    var lineCount: CGFloat = 4
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.clear(rect)
            
            if let backgroundColor = backgroundColor {
                backgroundColor.setFill()
                context.fill(rect)
            }
            
            if zoomScale > 0.3 {
                mode.draw(bounds: bounds, offset: offset, scale: zoomScale)
            }
            
            page.draw(bounds: bounds, offset: offset, scale: zoomScale, drawing: canvas.drawing)
        }
    }
}
