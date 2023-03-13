//
//  Document.Drawing+image.swift
//  Hippocampus (macOS)
//
//  Created by Guido Kühn on 12.03.23.
//

import AppKit
import CoreGraphics
import Foundation

extension Document.Drawing {
    var image: NSImage {
        let bounds = drawing.bounds
        let image = drawing.image(from: bounds, scale: 1)
        let rect = CGRect(origin: .zero, size: image.size)
        
        let result = NSImage(size: image.size)
        result.lockFocus()
        guard let context = NSGraphicsContext.current else { return image }
//        pageFormat.draw(bounds: rect, offset: bounds.topLeft, scale: 1, drawing: drawing, context: context)
        background.draw(bounds: rect, offset: bounds.topLeft, scale: 1, context: context)
        image.draw(in: rect)
        result.unlockFocus()
        return result

//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let context = CGContext(
//            data: nil,
//            width: Int(rect.width),
//            height: Int(rect.height),
//            bitsPerComponent: 8,
//            bytesPerRow: 0,
//            space: colorSpace,
//            bitmapInfo: bitmapInfo.rawValue)
//
//        let nscontext = NSGraphicsContext(cgContext: context!, flipped: true)
//        background.draw(bounds: rect, offset: bounds.topLeft, scale: 1, context: context!)
//        image.draw(in: rect)
//
//        let result = context!.makeImage()
//        return NSImage(cgImage: result!, size: rect.size)
    }
}
