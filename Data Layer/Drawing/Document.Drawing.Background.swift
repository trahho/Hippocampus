//
//  Document.Drawing.Background.swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation

extension Document.Drawing {
    enum Background: Int, Codable {
        case blank
        case grid
        case squares
        case lines
        case shorthand
        case shorthandGrid

        var printAs: Background {
            switch self {
            case .blank,
                 .grid:
                return .blank
            case .squares,
                 .lines,
                 .shorthand:
                return self
            case .shorthandGrid:
                return .shorthand
            }
        }
    }
}
