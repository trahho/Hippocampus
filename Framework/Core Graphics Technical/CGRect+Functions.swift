//
//  CGRect+borderPoint.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.05.22.
//

import CoreGraphics
import Foundation

extension CGRect {
    var center: CGPoint {
        origin + size / 2
    }

    var topLeft: CGPoint {
        CGPoint(x: minX, y: minY)
    }

    var topRight: CGPoint {
        CGPoint(x: maxY, y: minY)
    }

    var bottomLeft: CGPoint {
        CGPoint(x: minX, y: maxY)
    }

    var bottomRight: CGPoint {
        CGPoint(x: maxX, y: maxY)
    }
    
    var isNaN: Bool {
        origin.isNaN || size.isNaN
    }

    func borderPoint(to: CGPoint) -> CGPoint {
        let direction = to - center
        if direction.width == 0 {
            if direction.height < 0 {
                return CGPoint(x: center.x, y: minY)
            } else {
                return CGPoint(x: center.x, y: maxY)
            }
        } else if direction.height == 0 {
            if direction.width < 0 {
                return CGPoint(x: minX, y: center.y)
            } else {
                return CGPoint(x: maxX, y: center.y)
            }
        } else if abs((direction.height / direction.width) * width) < height { // wir müssen oben oder unten ansetzen
            if direction.width > 0 {
                return CGPoint(x: maxX, y: ((direction.height / direction.width) * (width / 2)) + center.y)
            } else {
                return CGPoint(x: minX, y: ((direction.height / direction.width) * (-width / 2)) + center.y)
            }
        } else { // links oder rechts
            if direction.height > 0 {
                return CGPoint(x: ((direction.width / direction.height) * (height / 2)) + center.x, y: maxY)
            } else {
                return CGPoint(x: ((direction.width / direction.height) * (-height / 2)) + center.x, y: minY)
            }
        }
    }

    func oppositeBorderPoint(to: CGPoint) -> CGPoint {
        borderPoint(to: CGPoint(2 * center - to))
    }

    func controlPoint(for target: CGPoint) -> CGPoint {
        let from = origin
        let to = origin + size
        return CGPoint(x: 2 * target.x - from.x / 2 - to.x / 2, y: 2 * target.y - from.y / 2 - to.y / 2)
    }

    init(firstPoint: CGPoint, secondPoint: CGPoint) {
        let topLeft = min(firstPoint, secondPoint)
        let bottomRight = max(firstPoint, secondPoint)
        self.init(origin: topLeft, size: bottomRight - topLeft)
    }

    func padding(_ size: CGFloat) -> CGRect {
        let size = CGSize(width: size, height: size)
        return CGRect(origin: origin - size, size: self.size + 2 * size)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(origin: center - size / 2, size: size)
    }
}
