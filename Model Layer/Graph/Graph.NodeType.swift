//
//  Graph.NodeType.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.05.23.
//

import Foundation

extension Graph {
    enum GraphNodeType {
        case unknown, anchor, knot, attribute, tie, edge, partition, testNode, testEdge

        var mass: CGFloat {
            switch self {
            case .unknown:
                return 0
            case .anchor:
                return 2
            case .knot:
                return 3
            case .attribute:
                return 5
            case .tie:
                return 5
            case .edge:
                return 2
            case .partition:
                return 0
            case .testNode:
                return 1
            case .testEdge:
                return 5
            }
        }

        var charge: CGFloat {
            switch self {
            case .unknown:
                return 0
            case .anchor:
                return 1
            case .knot:
                return 1
            case .attribute:
                return 1
            case .tie:
                return 1
            case .edge:
                return 4
            case .partition:
                return 0
            case .testNode:
                return 5
            case .testEdge:
                return 1
            }
        }
    }
    
}
