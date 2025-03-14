//
//  CGSize+Operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.22.
//

import CoreGraphics
import Foundation
import SwiftUI

extension CGSize {
    static func - (a: CGSize, b: CGSize) -> CGSize {
        CGSize(width: a.width - b.width, height: a.height - b.height)
    }

    static func - (a: CGSize, b: CGPoint) -> CGSize {
        a - CGSize(b)
    }

    static prefix func - (a: CGSize) -> CGSize {
        CGSize.zero - a
    }

    static func + (a: CGSize, b: CGSize) -> CGSize {
        CGSize(width: a.width + b.width, height: a.height + b.height)
    }

    static func + (a: CGSize, b: CGPoint) -> CGSize {
        a + CGSize(b)
    }

    static func * (size: CGSize, factor: CGFloat) -> CGSize {
        CGSize(width: size.width * factor, height: size.height * factor)
    }

    static func * (factor: CGFloat, size: CGSize) -> CGSize {
        size * factor
    }

    static func / (size: CGSize, factor: CGFloat) -> CGSize {
        CGSize(width: size.width / factor, height: size.height / factor)
    }

    static func / (size: CGSize, factor: CGSize) -> CGSize {
        CGSize(width: size.width / factor.width, height: size.height / factor.height)
    }

    static func / (size: CGSize, factor: CGPoint) -> CGSize {
        CGSize(width: size.width / factor.x, height: size.height / factor.y)
    }

    static func * (size: CGSize, factor: CGSize) -> CGSize {
        CGSize(width: size.width * factor.width, height: size.height * factor.height)
    }

    static func += (lhs: inout CGSize, rhs: CGPoint) {
        lhs = lhs + rhs
    }

    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }

    static func *= (lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs * rhs
    }

    static func -= (lhs: inout CGSize, rhs: CGPoint) {
        lhs = lhs - rhs
    }

    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs - rhs
    }

    var isEmpty: Bool {
        width + height == 0
    }

    var isNaN: Bool {
        width.isNaN || height.isNaN
    }

    var length: CGFloat {
        sqrt(width * width + height * height)
    }

    var angle: Angle {
        Angle(radians: atan2(height, width))
    }
    
    func rotate(by angle: Angle) -> CGSize {
        CGSize(width: width * cos(CGFloat(angle.radians)), height: height * sin(angle.radians))
    }

    static var infinity: CGSize {
        CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
    }

    init(_ point: CGPoint) {
        self.init(width: point.x, height: point.y)
    }
}
