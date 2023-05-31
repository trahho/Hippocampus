//
//  ExperimentSpringLayouter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.05.23.
//

import Foundation

class ExperimentSpringLayouter: GraphLayouter {
    var equilibrium: Bool = false

    let normalDistance: CGFloat = 20
    let attractionConstant: CGFloat
    let damping: CGFloat = 0.96
    let stoppingVelocity: CGFloat = 0.1
    let minimumStartingVelocity: CGFloat = 1
    let maximumStartingVelocity: CGFloat = 5
    let startingVelocityDelta: CGFloat
    let stiffness = 1.0
    var fuzziness: CGFloat = 0.1
    var fuzz: CGFloat
    var fuzzing: CGFloat = 0
    var partitionSize: CGFloat
    var partitionFactor: CGFloat = 15
    var longRangeEffect = 0.25
    var speed: CGFloat = 10
    var velocity: CGSize = .zero

    init() {
        attractionConstant = 1 / (normalDistance * normalDistance * normalDistance * normalDistance)
        startingVelocityDelta = maximumStartingVelocity - minimumStartingVelocity
        partitionSize = partitionFactor * normalDistance
        fuzz = partitionSize * fuzziness
    }

    func repell(node: Graph.Node, from other: Graph.Node, charge customcharge: CGFloat? = nil) {
        let nodePoint = node.bounds.borderPoint(to: other.position)
        let otherPoint = other.bounds.borderPoint(to: node.position)
        let charge = customcharge ?? (node.charge + other.charge) / 2
        let distance = nodePoint - otherPoint
        let force = distance.length.square
        let velocity = distance * speed * (charge / force)

        if node.bounds.intersects(other.bounds) {
            node.velocity -= velocity
        } else {
            node.velocity += velocity
        }
    }

    func attract(node: Graph.Node, to other: Graph.Node) {
        let nodePoint = node.bounds.borderPoint(to: other.position)
        let otherPoint = other.bounds.borderPoint(to: node.position)
        let mass = (node.mass + other.mass) / 2
        let distance = otherPoint - nodePoint
        let force = distance.length // CGFloat(edge.links.count)
        let velocity = distance * speed * (mass * force * attractionConstant)
        if node.bounds.intersects(other.bounds) {
            node.velocity -= velocity
        } else {
            node.velocity += velocity
        }
    }

    func attract(node: Graph.Node, to point: CGPoint) {
        let nodePoint = node.bounds.borderPoint(to: point)
        let mass = node.mass
        let distance = point - nodePoint
        let force = distance.length // CGFloat(edge.links.count)
        let velocity = distance * speed * (mass * force * attractionConstant)
        if node.bounds.contains(point) {
            node.velocity -= velocity
        } else {
            node.velocity += velocity
        }
    }

    func layout(graph: Graph) {
        guard graph.nodes.count > 1 else {
            equilibrium = true
            return
        }
        equilibrium = false
        let stoppedNodes = CGFloat(graph.nodes.filter { !$0.moving || $0.fixed }.count)
        let nodesCount = CGFloat(graph.nodes.count)
        var energy: CGFloat = 0
        var velocity: CGSize = .zero

        let crashedNodes = graph.nodes.filter { $0.bounds.isNaN }
        if !crashedNodes.isEmpty {
            speed -= 1
            crashedNodes.forEach {
                $0.position = .random(in: -100 ..< 600)
            }
        }

        let edges = graph.nodes.compactMap { $0 as? Graph.Edge }
        let nodes = graph.nodes.asSet.subtracting(edges).asArray

        for i in nodes.indices {
            let node = nodes[i]
            guard node.moving, !node.fixed else { continue }

            for j in nodes.indices {
                guard i != j else { continue }
                let other = nodes[j]
                repell(node: node, from: other)
            }
        }

        for i in edges.indices {
            let edge = edges[i]
            if edge.from == edge.to {
                repell(node: edge, from: edge.from)
                attract(node: edge, to: edge.from)
            } else {
                repell(node: edge.from, from: edge)
                repell(node: edge.to, from: edge)

                attract(node: edge.from, to: edge)
                attract(node: edge.to, to: edge)

                attract(node: edge, to: edge.from)
                attract(node: edge, to: edge.to)
                //                attract(node: edge, to: CGRect(firstPoint: edge.from.position, secondPoint: edge.to.position).center)
            }
            for j in edges.indices {
                guard i != j else { continue }
                let other = edges[j]
                repell(node: edge, from: other, charge: 0.1)
            }

            for node in nodes + edges {
                node.velocity *= damping

                velocity += node.velocity
                energy += abs(node.velocity.x) + abs(node.velocity.y)
                node.position += node.velocity
                node.velocity = .zero
            }
        }

//        print("Velocitydiff: \((velocity - self.velocity).length)")

        if energy / (nodesCount - stoppedNodes) < 20, speed < 100 {
            speed += 1
            print("Speed: \(speed)")
        }

        equilibrium = energy < (nodesCount - stoppedNodes) * stoppingVelocity || (velocity - self.velocity).length < 0.000001
        self.velocity = velocity
    }
}
