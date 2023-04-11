//
//  NSImage+scale.swift
//  Hippocampus (macOS)
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation
import UIKit

extension UIImage {
    func scale(factor: CGFloat) -> UIImage? {
        resize(withSize: size * factor)
    }

    func resize(withSize targetSize: CGSize) -> UIImage? {
        guard targetSize != size else {
            return self
        }

        let frame = CGRect(origin: .zero, size: targetSize)
        let renderer = UIGraphicsImageRenderer(bounds: frame)

        let image = renderer.image { _ in
            self.draw(in: frame)
        }

        return image
    }
}
