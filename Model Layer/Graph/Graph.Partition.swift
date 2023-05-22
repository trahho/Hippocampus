//
//  Graph.Partition.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.23.
//

import Foundation

extension Graph {
    class Partition: Node {
        var nodes: [Node] = []
        var totalCharge: CGFloat = 0
        var totalMass: CGFloat = 0
        
        var border: CGRect = .zero

        func add(node: Node) {
            nodes.append(node)
            position = (position * totalMass + node.position * node.mass) / (totalMass / node.mass)
            border = border.union(node.bounds)
            
        }
    }
}
