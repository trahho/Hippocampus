//
//  Presentation.Layout.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.07.24.
//

import Grisu
import SwiftUI

extension Presentation {
    enum Layout: Structure.PersistentValue, PickableEnum {
        case list
        case tree
        case canvas
        case mindMap
        case miniMindMiap
        case gallery
        case item

        // MARK: Computed Properties

        var description: String {
            switch self {
            case .list:
                "list"
            case .tree:
                "tree"
            case .canvas:
                "canvas"
            case .mindMap:
                "mindMap"
            case .miniMindMiap:
                "miniMindMiap"
            case .gallery:
                "gallery"
            case .item:
                "item"
            }
        }

        var icon: Image {
            let name = switch self {
            case .list:
                "list.bullet"
            case .tree:
                "list.bullet.indent"
            case .canvas:
                "rectangle.3.group"
            case .mindMap:
                "point.3.filled.connected.trianglepath.dotted"
            case .miniMindMiap:
                "circle.hexagongrid.fill"
            case .gallery:
                "square.grid.3x3.square"
            case .item:
                "magnifyingglass"
            }
            return Image(systemName: name)
        }
    }
}
