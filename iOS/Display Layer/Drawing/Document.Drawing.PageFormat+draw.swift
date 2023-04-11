//
//  PencilCanvasView.PageFormat.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.02.23.
//

import Foundation
import PencilKit
import UIKit

extension Document.Drawing.PageFormat {
    func draw(bounds: CGRect, offset: CGPoint, scale: CGFloat, drawing: PKDrawing, context: CGContext) {
        guard self != .infinite else { return }

        let horizontalLinesDistance: CGFloat = Self.pointsPerCm * contentBounds.height
        let verticalLinesDistance: CGFloat = Self.pointsPerCm * contentBounds.width

        let numberOfHorizontalLines = (bounds.height / (scale * horizontalLinesDistance)).rounded(.up)
        let numberOfVerticalLines = (bounds.width / (scale * verticalLinesDistance)).rounded(.up)

        let horizontalOffset = offset.x.truncatingRemainder(dividingBy: verticalLinesDistance * scale)
        let verticalOffset = offset.y.truncatingRemainder(dividingBy: horizontalLinesDistance * scale)

        let horizontalPath = UIBezierPath()
        let verticalPath = UIBezierPath()

        for i in 0 ... Int(numberOfHorizontalLines) {
            let offset = (CGFloat(i) * horizontalLinesDistance * scale) - verticalOffset
            horizontalPath.move(to: CGPoint(x: bounds.minX, y: offset))
            horizontalPath.addLine(to: CGPoint(x: bounds.maxX, y: offset))
        }
        for i in 0 ... Int(numberOfVerticalLines) {
            let offset = (CGFloat(i) * verticalLinesDistance * scale) - horizontalOffset
            verticalPath.move(to: CGPoint(x: offset, y: bounds.minY))
            verticalPath.addLine(to: CGPoint(x: offset, y: bounds.maxY))
        }

        context.saveGState()
        UIColor.opaqueSeparator.withAlphaComponent(0.7).setStroke()

        horizontalPath.lineWidth = 5
        horizontalPath.stroke()
        verticalPath.lineWidth = 5
        verticalPath.stroke()

        if self != .infinite {
            let viewBounds = CGRect(origin: offset, size: bounds.size)
            let pages = getPages(for: drawing)
            let font = UIFont(name: "Raleway", size: 300 * scale)!
            for i in 0 ..< pages.count {
                let page = pages[i]
                let pageFrame = CGRect(x: page.minX * scale, y: page.minY * scale, width: page.width * scale, height: page.height * scale)
                if pageFrame.intersects(viewBounds) {
                    let pageOrigin = CGPoint(x: pageFrame.minX - offset.x, y: pageFrame.minY - offset.y)
                    let pageBounds = CGRect(origin: pageOrigin, size: pageFrame.size)
                    let pageNumber = NSAttributedString(string: "\(i + 1)",
                                                        attributes: [
                                                            NSAttributedString.Key.font: font,
                                                            NSAttributedString.Key.strokeColor: UIColor.opaqueSeparator.withAlphaComponent(0.5),
                                                            NSAttributedString.Key.strokeWidth: 2,
                                                            NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator.withAlphaComponent(0.4),
                                                        ])
                    let size = pageNumber.size()
                    pageNumber.draw(at: CGPoint(x: pageBounds.minX + size.width / 2, y: pageBounds.minY - size.width / 4))
                }
            }
        }

        context.restoreGState()
    }
}
