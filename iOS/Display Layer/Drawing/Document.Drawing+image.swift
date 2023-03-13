//
//  Document.Drawing+image.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 12.03.23.
//

import Foundation
import UIKit

extension Document.Drawing {
    var image: UIImage {
        let bounds = drawing.bounds
        let image = drawing.image(from: bounds, scale: 1)

        UIGraphicsBeginImageContext(image.size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return image
        }

        let rect = CGRect(origin: .zero, size: image.size)
//        pageFormat.draw(bounds: rect, offset: bounds.topLeft, scale: 1, drawing: drawing, context: context)
        background.draw(bounds: rect, offset: bounds.topLeft, scale: 1, context: context)
        image.draw(in: rect)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result ?? image
    }
}
