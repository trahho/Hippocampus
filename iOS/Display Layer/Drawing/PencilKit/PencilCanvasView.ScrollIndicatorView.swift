//
//  PencilCanvasView.ScrollIndicatorView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.02.23.
//

import Foundation
import UIKit

extension PencilCanvasView {
    class ScrollIndicatorView: UIView {
        enum Direction {
            case horizontal
            case vertical
        }

        private var thumbFrame = CGRect.zero

        var thumbMinWidth: CGFloat = 10
        var thumbMinHeight: CGFloat = 10

        var mode = Direction.horizontal

        func setThumb(start: CGFloat, end: CGFloat) {
            let frameMin = thumbMinWidth
            let frameMax = (mode == .horizontal ? bounds.width : bounds.height) - thumbMinWidth

            var thumbStart = max(frameMin, min(frameMax, start))
            var thumbEnd = max(frameMin, min(frameMax, end))
            let thumbWidth = thumbEnd - thumbStart

            if thumbWidth < thumbMinWidth {
                if thumbStart == frameMin {
                    thumbEnd = thumbStart + thumbMinWidth
                } else if thumbEnd == frameMax {
                    thumbStart = thumbEnd - thumbMinWidth
                } else {
                    let mid = min(thumbStart, thumbEnd) + abs(thumbWidth) / 2
                    thumbStart = mid - thumbMinWidth / 2
                    thumbEnd = mid + thumbMinWidth / 2
                }
            } else if thumbStart == frameMin, thumbEnd == frameMax {
                thumbStart = 0
                thumbEnd = 0
            }

            switch mode {
            case .horizontal:
                thumbFrame = CGRect(x: thumbStart, y: bounds.minY, width: thumbEnd - thumbStart, height: bounds.height)
            case .vertical:
                thumbFrame = CGRect(x: bounds.minX, y: thumbStart, width: bounds.width, height: thumbEnd - thumbStart)
            }
            setNeedsDisplay()
        }

        override func draw(_ rect: CGRect) {
            super.draw(rect)

            guard let context = UIGraphicsGetCurrentContext() else { return }

            context.clear(rect)

            guard thumbFrame.width > 0, thumbFrame.height > 0 else { return }

            if let tintColor = tintColor {
                tintColor.setFill()
                let path = UIBezierPath(roundedRect: thumbFrame, cornerRadius: min(thumbFrame.width, thumbFrame.height) / 2)
                path.fill()
            }
        }
    }
}
