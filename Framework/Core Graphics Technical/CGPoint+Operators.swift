//
//  CGPoint+Operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.22.
//

import CoreGraphics
import Foundation

extension CGPoint {
    // MARK: - +

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func + (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x + size.width, y: point.y + size.height)
    }

    // MARK: - -

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGSize {
        CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }

    static func - (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x - size.width, y: point.y - size.height)
    }

    // MARK: - *

    static func * (point: CGPoint, factor: CGFloat) -> CGPoint {
        CGPoint(x: point.x * factor, y: point.y * factor)
    }

    static func * (factor: CGFloat, point: CGPoint) -> CGPoint {
        point * factor
    }

    static func * (point: CGPoint, factor: Double) -> CGPoint {
        point * CGFloat(factor)
    }

    static func * (factor: Double, point: CGPoint) -> CGPoint {
        point * CGFloat(factor)
    }

    static func * (point: CGPoint, factor: Int) -> CGPoint {
        point * CGFloat(factor)
    }

    static func * (factor: Int, point: CGPoint) -> CGPoint {
        point * CGFloat(factor)
    }

    static func * (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x * size.width, y: point.y * size.height)
    }

    // MARK: - /

    static func / (point: CGPoint, factor: CGFloat) -> CGPoint {
        CGPoint(x: point.x / factor, y: point.y / factor)
    }

    static func / (point: CGPoint, factor: Double) -> CGPoint {
        point / CGFloat(factor)
    }

    static func / (point: CGPoint, factor: Int) -> CGPoint {
        point / CGFloat(factor)
    }

    // MARK: - Functions

    static var infinite: CGPoint {
        CGPoint(x: CGFloat.infinity, y: CGFloat.infinity)
    }
    
    static func < (lhs:CGPoint, rhs:CGPoint) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }

    // MARK: - Initialization

    init(_ size: CGSize) {
        self.init(x: size.width, y: size.height)
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
