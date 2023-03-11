//
//  PkDrawing+strokesIn.swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation
import PencilKit

extension PKDrawing {
    func strokesIn(bounds: CGRect) -> [PKStroke] {
        strokes
            .filter { stroke in
                stroke.renderBounds.intersects(bounds)
            }
    }
}
