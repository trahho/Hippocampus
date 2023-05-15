//
//  Graph.NodeType.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.05.23.
//

import Foundation

extension Graph {
    enum GraphNodeType: Int {
        private static let masses = [0, 2, 3, 5, 5, 2, 0, 8]
        private static let charges = [0, 1, 1, 1, 1, 4, 0, 1]

        case unknown = 0
        case anchor = 1
        case knot = 2
        case attribute = 3
        case tie = 4
        case edge = 5
        case partition = 6
        case trial = 7

        var mass: Int {
            Self.masses[rawValue]
        }

        var charge: Int {
            Self.charges[rawValue]
        }
    }
    
}
