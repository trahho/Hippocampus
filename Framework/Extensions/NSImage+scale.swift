//
//  NSImage+scale.swift
//  Hippocampus (macOS)
//
//  Created by Guido Kühn on 11.03.23.
//

import AppKit
import Foundation

extension NSImage {
    func scale(factor: CGFloat) -> NSImage? {
        resize(withSize: size * factor)
    }

    func resize(withSize targetSize: CGSize) -> NSImage? {
        guard targetSize != size else {
            return self
        }

        let frame = CGRect(origin: .zero, size: targetSize)
        guard let representation = bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { _ -> Bool in
            representation.draw(in: frame)
        })

        return image
    }
}
