//
//  ComplexSpringLayouter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.23.
//

import Foundation

class MySpringLayouter: GraphLayouter {
    var equilibrium: Bool = false

    let normalDistance: CGFloat = 20
    let attractionConstant: CGFloat
    let damping: CGFloat = 0.96
    let stoppingVelocity: CGFloat = 0.001
    let minimumStartingVelocity: CGFloat = 1
    let maximumStartingVelocity: CGFloat = 5
    let startingVelocityDelta: CGFloat
    let stiffness = 1.0
    var speed = 5.0

    init() {
        attractionConstant = 1 / (normalDistance * normalDistance * normalDistance)
        startingVelocityDelta = maximumStartingVelocity - minimumStartingVelocity
    }

    func attract(from: Graph.Node, to: Graph.Node) {
        let fromPoint = from.bounds.borderPoint(to: to.position)
        let toPoint = to.bounds.borderPoint(to: from.position)
        let attracting = speed * (fromPoint - toPoint) * ((from.mass + to.mass) / 2) * attractionConstant
        let fromAttracting = attracting / from.stability
        let toAttracting = attracting / to.stability
        from.velocity = from.velocity - (from.fixed ? .zero : fromAttracting)
        to.velocity = to.velocity + (to.fixed ? .zero : toAttracting)
    }

    func repell(from: Graph.Node, to: Graph.Node) {
        let fromPoint = from.bounds.borderPoint(to: to.position)
        let toPoint = to.bounds.borderPoint(to: from.position)
        let distanceSquare = (fromPoint - toPoint).length.square
        let repelling = speed * (fromPoint - toPoint) * (((from.charge + to.charge) / 2) / distanceSquare)
        let fromRepelling = repelling / from.stability
        let toRepelling = (CGSize.zero - repelling) / to.stability

        if from.bounds.intersects(to.bounds) {
            from.velocity = from.velocity - (from.fixed ? .zero : fromRepelling)
            to.velocity = to.velocity - (to.fixed ? .zero : toRepelling)
        } else {
            from.velocity = from.velocity + (from.fixed ? .zero : fromRepelling)
            to.velocity = to.velocity + (to.fixed ? .zero : toRepelling)
        }
    }

    func align(edge: Graph.Edge, bounds: CGRect) {
//        guard let alignment = edge.alignment else { return }
//        return
//        var targetPoint: CGPoint = .zero
//
//        switch alignment {
//        case .topLeading:
//            let from = edge.from.bounds.topLeft
//            let to = edge.to.bounds.bottomRight
//            if to.x >= from.x, to.y >= from.y {
//                edge.to.velocity = edge.to.velocity + CGPoint(x: -10, y: -10)
//            }
//        case .topTrailing:
//            targetPoint = bounds.topRight
//        case .bottomLeading:
//            targetPoint = bounds.bottomLeft
//        case .bottomTrailing:
//            targetPoint = bounds.bottomRight
//        case .top:
//            targetPoint = bounds.topLeft + CGPoint(x: node.position.x, y: 0)
//        case .leading:
//            targetPoint = bounds.topLeft + CGPoint(x: 0, y: node.position.y)
//        case .bottom:
//            targetPoint = bounds.bottomLeft + CGPoint(x: node.position.x, y: 0)
//        case .trailing:
//            targetPoint = bounds.topRight + CGPoint(x: 0, y: node.position.y)
//        case .center:
//            targetPoint = bounds.center
//        default:
//            fatalError("No layout for alignment")
//        }

//        let nodePoint = node.bounds.borderPoint(to: targetPoint)
        ////        let attracting = nodePoint - targetPoint * node.mass * attractionConstant / node.stability
//        let attracting = (nodePoint - targetPoint) * attractionConstant * 2 / node.stability
//
//        node.velocity = node.velocity - (node.fixed ? .zero : attracting)
    }

    func layout(graph: Graph) {
        guard graph.nodes.count > 1 else {
            equilibrium = true
            return
        }
        equilibrium = false
        let numberOfNodes = CGFloat(graph.nodes.count)
//        let attractionFactor = sqrt((1000 * 1000) / numberOfNodes)
        var numberOfStoppedNodes: CGFloat = 0

        var energy = 0.0

        for edge in graph.edges {
            if edge.to.visible, edge.from.visible {
                attract(from: edge.from, to: edge.to)
                align(edge: edge, bounds: graph.bounds.padding(0))
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

            for j in (i + 1 ..< graph.nodes.count).reversed() {
                let otherNode = graph.nodes[j]
                repell(from: otherNode, to: node)
            }

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

        equilibrium = energy < Double(numberOfNodes - numberOfStoppedNodes) * stoppingVelocity
    }
}
