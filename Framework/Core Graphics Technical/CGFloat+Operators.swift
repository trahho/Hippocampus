//
//  CGFloat+Operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.22.
//

import Foundation
import CoreGraphics

extension CGFloat {
    var square : CGFloat {
        self * self
    }
    
    var sign: CGFloat {
        self < 0 ? -1 : 1
    }
}
