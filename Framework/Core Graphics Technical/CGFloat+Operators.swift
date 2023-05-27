//
//  CGFloat+Operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.22.
//

import CoreGraphics
import Foundation

extension CGFloat {
    var square: CGFloat {
        self * self
    }

    var sign: CGFloat {
        self < 0 ? -1 : 1
    }
}

func mid (_ lhs: CGFloat, _ rhs: CGFloat) -> CGFloat {
    (lhs + rhs) / 2
}
