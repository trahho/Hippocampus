//
//  CGPoint+Operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.22.
//

import CoreGraphics
import Foundation

extension CGPoint {
    static func - (a: CGPoint, b: CGPoint) -> CGSize {
        CGSize(width: a.x - b.x, height: a.y - b.y)
    }

    static func - (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x - size.width, y: point.y - size.height)
    }

    static func + (a: CGPoint, b: CGPoint) -> CGPoint {
        CGPoint(x: a.x + b.x, y: a.y + b.y)
    }

    static func + (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x + size.width, y: point.y + size.height)
    }

    static func * (point: CGPoint, factor: CGFloat) -> CGPoint {
        CGPoint(x: point.x * factor, y: point.y * factor)
    }

    static func * (factor: CGFloat, point: CGPoint) -> CGPoint {
        point * factor
    }

    static func * (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x * size.width, y: point.y * size.height)
    }

    static func / (point: CGPoint, factor: CGFloat) -> CGPoint {
        CGPoint(x: point.x / factor, y: point.y / factor)
    }

    static var infinite: CGPoint {
        CGPoint(x: CGFloat.infinity, y: CGFloat.infinity)
    }
}

func min(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    CGPoint(x: min(a.x, b.x), y: min(a.y, b.y))
}

func max(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
    CGPoint(x: max(a.x, b.x), y: max(a.y, b.y))
}

func abs(_ point: CGPoint) -> CGPoint {
    CGPoint(x: abs(point.x), y: abs(point.y))
}
