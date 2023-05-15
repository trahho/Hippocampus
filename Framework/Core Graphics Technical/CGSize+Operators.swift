//
//  CGSize+Operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.22.
//

import CoreGraphics
import Foundation

extension CGSize {
    static func - (a: CGSize, b: CGSize) -> CGSize {
        CGSize(width: a.width - b.width, height: a.height - b.height)
    }

    static func + (a: CGSize, b: CGSize) -> CGSize {
        CGSize(width: a.width + b.width, height: a.height + b.height)
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

    var isEmpty: Bool {
        width + height == 0
    }

    var length: CGFloat {
        sqrt(width * width + height * height)
    }

    init(_ point: CGPoint) {
        self.init(width: point.x, height: point.y)
    }
}
