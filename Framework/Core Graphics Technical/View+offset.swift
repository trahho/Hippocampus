//
//  View+offset.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.05.22.
//

import CoreGraphics
import Foundation
import SwiftUI

extension View {
    func offset(position: CGPoint) -> some View {
        self.offset(x: position.x, y: position.y)
    }
}
