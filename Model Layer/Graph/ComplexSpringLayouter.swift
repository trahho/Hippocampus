//
//  ComplexSpringLayouter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.23.
//

import Foundation

class ComplexSpringLayouter: GraphLayouter {
    let attractionConstant: CGFloat = 1 / (20 * 20 * 20)
    let damping: CGFloat = 0.96
    let stoppingVelocity: CGFloat = 0.001
    let minimumStartingVelocity: CGFloat = 1
    let maximumStartingVelocity: CGFloat = 5
    let startingVelocityDelta: CGFloat = 4
    let stiffness = 1.0

    func attract(from: Graph.GraphNode, to: Graph.GraphNode) {
        let fromPoint = from.layoutBounds.borderPoint(to: to.position)
        let toPoint = to.layoutBounds.borderPoint(to: from.position)
        let attracting = (fromPoint - toPoint) * ((from.mass + to.mass) / 2) * attractionConstant
        let fromAttracting = attracting / from.stability
        let toAttracting = attracting / to.stability
        from.velocity = from.velocity - (from.fixed ? .zero : fromAttracting)
        to.velocity = to.velocity + (to.fixed ? .zero : toAttracting)
    }

    func repell(from: Graph.GraphNode, to: Graph.GraphNode) {
        let fromPosition = from.position + from.velocity
        let toPosition = to.position + to.velocity
        let fromBounds = CGRect(center: fromPosition, size: from.size)
        let toBounds = CGRect(center: toPosition, size: to.size)
        let fromPoint = fromBounds.borderPoint(to: toPosition)
        let toPoint = toBounds.borderPoint(to: fromPosition)
        let distanceSquare = (fromPoint - toPoint).length.square
        let repelling = (fromPoint - toPoint) * (((from.charge + to.charge) / 2) / distanceSquare)
        let fromRepelling = repelling / from.stability
        let toRepelling = (CGSize.zero - repelling) / to.stability

        if fromBounds.intersects(toBounds) {
            from.velocity = from.velocity - (from.fixed ? .zero : fromRepelling)
            to.velocity = to.velocity - (to.fixed ? .zero : toRepelling)
        } else {
            from.velocity = from.velocity + (from.fixed ? .zero : fromRepelling)
            to.velocity = to.velocity + (to.fixed ? .zero : toRepelling)
        }
    }

    func align(node: Graph.GraphNode, bounds: CGRect) {
        guard let alignment = node.alignment else { return }

        var targetPoint: CGPoint = .zero

        switch alignment {
        case .topLeading:
            targetPoint = bounds.topLeft
        case .topTrailing:
            targetPoint = bounds.topRight
        case .bottomLeading:
            targetPoint = bounds.bottomLeft
        case .bottomTrailing:
            targetPoint = bounds.bottomRight
        case .top:
            targetPoint = bounds.topLeft + CGPoint(x: node.position.x, y: 0)
        case .leading:
            targetPoint = bounds.topLeft + CGPoint(x: 0, y: node.position.y)
        case .bottom:
            targetPoint = bounds.bottomLeft + CGPoint(x: node.position.x, y: 0)
        case .trailing:
            targetPoint = bounds.topRight + CGPoint(x: 0, y: node.position.y)
        case .center:
            targetPoint = bounds.center
        default:
            fatalError("No layout for alignment")
        }

        let nodePoint = node.bounds.borderPoint(to: targetPoint)
//        let attracting = nodePoint - targetPoint * node.mass * attractionConstant / node.stability
        let attracting = (nodePoint - targetPoint) * attractionConstant * 2 / node.stability

        node.velocity = node.velocity - (node.fixed ? .zero : attracting)
    }

    func layout(graph: Graph) {
        guard graph.nodes.count > 1 else {
            graph.stopLayout()
            return
        }
        let numberOfNodes = CGFloat(graph.nodes.count)
//        let attractionFactor = sqrt((1000 * 1000) / numberOfNodes)
        var numberOfStoppedNodes: CGFloat = 0

        var energy = 0.0

        for edge in graph.edges {
            if edge.to.visible, edge.from.visible {
                attract(from: edge.from, to: edge.to)
                let start = edge.from.bounds.borderPoint(to: edge.position)
                let end = edge.to.bounds.padding(20).borderPoint(to: edge.position)
                let curvature = stiffness / (start - end).length
                let controlPoint = CGRect(firstPoint: start, secondPoint: end).controlPoint(for: edge.position)
                edge.velocity = edge.velocity - curvature * (controlPoint - edge.position)
            }
        }

        for i in 0 ..< graph.nodes.count - 1 {
            let node = graph.nodes[i]
            if !node.moving || node.fixed {
                numberOfStoppedNodes += 1
            }

            for j in i + 1 ..< graph.nodes.count {
                let otherNode = graph.nodes[j]
                repell(from: otherNode, to: node)
            }

            align(node: node, bounds: graph.bounds.padding(0))

            node.velocity = node.velocity * damping

            let nodeVelocity: CGFloat = abs(node.velocity.x) + abs(node.velocity.y)
            if nodeVelocity <= stoppingVelocity {
                node.moving = false
            } else if nodeVelocity > minimumStartingVelocity + startingVelocityDelta * numberOfStoppedNodes / numberOfNodes {
                node.moving = true
            }

            if node.moving, !node.fixed {
                energy += nodeVelocity
            }
        }

        if energy < Double(numberOfNodes - numberOfStoppedNodes) * stoppingVelocity {
            graph.nodes.forEach {
                $0.stability = 10
            }
            graph.stopLayout()
        }
    }
}
