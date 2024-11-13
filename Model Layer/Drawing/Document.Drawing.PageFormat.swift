//
//  Document.Drawing.PageFormat.swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation
import PencilKit

//extension Document.Drawing {
//    enum PageFormat: Int, Codable {
//        case infinite
//        case A4
//        case A5
//        case A4quer
//        case A5quer
//
//        static var pointsPerCm: CGFloat {
//            50
//        }
//
//        static var lineDistance: CGFloat {
//            1.2
//        }
//
//        var size: CGSize {
//            switch self {
//            case .infinite:
//                return CGRect.infinite.size
//            case .A4:
//                return CGSize(width: 21 - 0.9, height: 29.7 - 1.3)
//            case .A5:
//                return CGSize(width: 14.8, height: 21)
//            case .A4quer:
//                return CGSize(width: 29.7 - 0.9, height: 21 - 1.3)
//            case .A5quer:
//                return CGSize(width: 21, height: 14.8)
//            }
//        }
//
//        var contentBounds: CGRect {
//            switch self {
//            case .infinite:
//                return CGRect.infinite
//            case .A4:
//                //            return CGRect(x: 2.5, y: 1.5, width: 17, height: 26)
//                // 1cm            return CGRect(x: 1, y: 0.7 + 0.25, width: 19, height: 27)
//                // final:
//                return CGRect(x: 1.5, y: 1.5, width: 18, height: 26.4)
//            case .A5:
//                return CGRect(x: 1, y: 0.5, width: 13.5, height: 20)
//            case .A4quer:
//                // 1cm            return CGRect(x: 0.4, y: 1.25, width: 28, height: 18)
//                return CGRect(x: 0, y: 1.25, width: 28.8, height: 18)
//            case .A5quer:
//                return CGRect(x: 1, y: 0.5, width: 20, height: 13.5)
//            }
//        }
//
//        func getPages(for drawing: PKDrawing) -> [CGRect] {
//            var result: [CGRect] = []
//
//            if self == .infinite {
//                result.append(drawing.bounds)
//            } else {
//                var point = CGPoint(x: drawing.bounds.minX, y: drawing.bounds.minY)
//                var bounds = pageFrame(for: point)
//                repeat {
//                    repeat {
//                        if !drawing.strokes(in: bounds).isEmpty {
//                            result.append(bounds)
//                        }
//                        point = CGPoint(x: bounds.maxX + 1, y: bounds.minY)
//                        bounds = pageFrame(for: point)
//                    } while bounds.minX < drawing.bounds.maxX
//                    point = CGPoint(x: drawing.bounds.minX, y: bounds.maxY + 1)
//                    bounds = pageFrame(for: point)
//                } while bounds.minY < drawing.bounds.maxY
//            }
//
//            return result
//        }
//
//        func pageFrame(for point: CGPoint) -> CGRect {
//            guard self != .infinite else { return CGRect.infinite }
//
//            let horizontalSize: CGFloat = Self.pointsPerCm * contentBounds.width
//            let verticalSize: CGFloat = Self.pointsPerCm * contentBounds.height
//
//            let horizontalOffset = point.x.truncatingRemainder(dividingBy: horizontalSize)
//            let verticalOffset = point.y.truncatingRemainder(dividingBy: verticalSize)
//
//            return CGRect(x: point.x - horizontalOffset, y: point.y - verticalOffset, width: horizontalSize, height: verticalSize)
//        }
//    }
//}
