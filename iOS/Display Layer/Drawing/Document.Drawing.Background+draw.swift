//
//  PencilCanvasView.Background.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.02.23.
//

import Foundation
import UIKit

extension Document.Drawing.Background {
    func draw(bounds: CGRect, offset: CGPoint, scale: CGFloat, context: CGContext) {
            
        if self == .blank { return }
            
        let lineCount: CGFloat = 4
        let lineDistance: CGFloat = Document.Drawing.PageFormat.lineDistance * Document.Drawing.PageFormat.pointsPerCm * scale / lineCount
            
        let numberOfHorizontalLines = (bounds.height / lineDistance).rounded(.up) + lineCount
        let numberOfVerticalLines = (bounds.width / lineDistance).rounded(.up) + lineCount
            
        let verticalOffset = offset.y.truncatingRemainder(dividingBy: lineDistance * lineCount)
        let horizontalOffset = offset.x.truncatingRemainder(dividingBy: lineDistance * lineCount)
            
        let horizontalPaths = [UIBezierPath(), UIBezierPath(), UIBezierPath(), UIBezierPath()]
        let verticalPaths = [UIBezierPath(), UIBezierPath(), UIBezierPath(), UIBezierPath()]
            
        for i in 0 ... Int(numberOfHorizontalLines) {
            let offset = (CGFloat(i) * lineDistance) - verticalOffset + bounds.minY
            let path = i % Int(4)
            if offset >= bounds.minY, offset <= bounds.maxY + lineDistance {
                horizontalPaths[path].move(to: CGPoint(x: bounds.minX, y: offset))
                horizontalPaths[path].addLine(to: CGPoint(x: bounds.maxX, y: offset))
            }
        }
        for i in 0 ... Int(numberOfVerticalLines) {
            let offset = (CGFloat(i) * lineDistance) - horizontalOffset + bounds.minX
            let path = i % Int(4)
            if offset >= bounds.minX, offset <= bounds.maxX + lineDistance {
                verticalPaths[path].move(to: CGPoint(x: offset, y: bounds.minY))
                verticalPaths[path].addLine(to: CGPoint(x: offset, y: bounds.maxY))
            }
        }
            
        context.saveGState()
        UIColor.gray.setStroke()
            
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
            context.setLineDash(phase: horizontalOffset + lineDistance / 16, lengths: [lineDistance / 8, lineDistance / 8])
            horizontalPaths[1].lineWidth = 0.75
            horizontalPaths[1].stroke()
            horizontalPaths[2].lineWidth = 0.75
            horizontalPaths[2].stroke()
            horizontalPaths[3].lineWidth = 0.75
            horizontalPaths[3].stroke()
        case .lines:
            horizontalPaths[0].lineWidth = 1
            horizontalPaths[0].stroke()
        case .grid:
            context.setLineDash(phase: horizontalOffset + lineDistance / 8, lengths: [lineDistance / 4, lineDistance * 3 / 4])
            horizontalPaths[0].lineWidth = 0.75
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
            context.setLineDash(phase: verticalOffset + lineDistance / 8, lengths: [lineDistance / 4, lineDistance * 3 / 4])
            verticalPaths[0].lineWidth = 0.75
            verticalPaths[0].stroke()
        case .grid:
            context.setLineDash(phase: verticalOffset + 2.5 * scale, lengths: [lineDistance / 4, lineDistance * 3 / 4])
            verticalPaths[0].lineWidth = 0.75
            verticalPaths[0].stroke()
        }
        context.restoreGState()
    }
}
