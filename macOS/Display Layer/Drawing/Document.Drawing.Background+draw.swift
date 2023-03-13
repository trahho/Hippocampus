//
//  PencilCanvasView.Background.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.02.23.
//

import AppKit
import Foundation

extension Document.Drawing.Background {
    func draw(bounds: CGRect, offset: CGPoint, scale: CGFloat, context: NSGraphicsContext) {
        if self == .blank { return }
            
        let lineCount: CGFloat = 4
        let lineDistance: CGFloat = Document.Drawing.PageFormat.lineDistance * Document.Drawing.PageFormat.pointsPerCm * scale / lineCount
            
        let numberOfHorizontalLines = (bounds.height / lineDistance).rounded(.up) + lineCount
        let numberOfVerticalLines = (bounds.width / lineDistance).rounded(.up) + lineCount
            
        let verticalOffset = offset.y.truncatingRemainder(dividingBy: lineDistance * lineCount)
        let horizontalOffset = offset.x.truncatingRemainder(dividingBy: lineDistance * lineCount)
            
        let horizontalPaths = [NSBezierPath(), NSBezierPath(), NSBezierPath(), NSBezierPath()]
        let verticalPaths = [NSBezierPath(), NSBezierPath(), NSBezierPath(), NSBezierPath()]
            
        for i in 0 ... Int(numberOfHorizontalLines) {
            let offset = (CGFloat(i) * lineDistance) - verticalOffset + bounds.minY
            let path = i % Int(4)
            if offset >= bounds.minY, offset <= bounds.maxY + lineDistance {
                horizontalPaths[path].move(to: CGPoint(x: bounds.minX, y: bounds.maxY - offset))
                horizontalPaths[path].line(to: CGPoint(x: bounds.maxX, y: bounds.maxY - offset))
            }
        }
        for i in 0 ... Int(numberOfVerticalLines) {
            let offset = (CGFloat(i) * lineDistance) - horizontalOffset + bounds.minX
            let path = i % Int(4)
            if offset >= bounds.minX, offset <= bounds.maxX + lineDistance {
                verticalPaths[path].move(to: CGPoint(x: offset, y: bounds.minY))
                verticalPaths[path].line(to: CGPoint(x: offset, y: bounds.maxY))
            }
        }
            
        context.saveGraphicsState()
        let color = NSColor.systemGray
        color.setStroke()
            
        switch self {
        case .blank:
            break
        case .squares:
            horizontalPaths[0].lineWidth = 1
            horizontalPaths[0].stroke()
            horizontalPaths[2].lineWidth = 1
            horizontalPaths[2].stroke()
        case .shorthand,
             .shorthandGrid:
            horizontalPaths[0].lineWidth = 1
            horizontalPaths[0].stroke()
            horizontalPaths[1].lineWidth = 0.75
            horizontalPaths[1].setLineDash([lineDistance / 8, lineDistance / 8], count: 2, phase: horizontalOffset + lineDistance / 16)
            horizontalPaths[1].stroke()
            horizontalPaths[2].lineWidth = 0.75
            horizontalPaths[2].setLineDash([lineDistance / 8, lineDistance / 8], count: 2, phase: horizontalOffset + lineDistance / 16)
            horizontalPaths[2].stroke()
            horizontalPaths[3].lineWidth = 0.75
            horizontalPaths[3].setLineDash([lineDistance / 8, lineDistance / 8], count: 2, phase: horizontalOffset + lineDistance / 16)
            horizontalPaths[3].stroke()
        case .lines:
            horizontalPaths[0].lineWidth = 1
            horizontalPaths[0].stroke()
        case .grid:
            horizontalPaths[0].lineWidth = 0.75
            horizontalPaths[0].setLineDash([lineDistance / 4, lineDistance * 3 / 4], count: 2, phase: horizontalOffset + lineDistance / 8)
            horizontalPaths[0].stroke()
        }
            
        switch self {
        case .blank,
             .shorthand,
             .lines:
            break
        case .squares:
            verticalPaths[0].lineWidth = 1
            verticalPaths[0].stroke()
            verticalPaths[2].lineWidth = 1
            verticalPaths[2].stroke()
        case .shorthandGrid:
            verticalPaths[0].lineWidth = 0.75
            verticalPaths[0].setLineDash([lineDistance / 4, lineDistance * 3 / 4], count: 2, phase: horizontalOffset + lineDistance / 8)
            verticalPaths[0].stroke()
        case .grid:
            verticalPaths[0].lineWidth = 0.75
            verticalPaths[0].setLineDash([lineDistance / 4, lineDistance * 3 / 4], count: 2, phase: verticalOffset + 2.5 * scale)
            verticalPaths[0].stroke()
        }
        context.restoreGraphicsState()
    }
}
