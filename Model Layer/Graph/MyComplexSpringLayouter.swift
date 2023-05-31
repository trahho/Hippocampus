//
//  MyComplexSprintLayouter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.05.23.
//

import Foundation

class MyComplexSpringLayouter: GraphLayouter {
    var equilibrium: Bool = false

    let normalDistance: CGFloat = 30
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
        attractionConstant = 1 / (normalDistance * normalDistance * normalDistance)
        startingVelocityDelta = maximumStartingVelocity - minimumStartingVelocity
        partitionSize = partitionFactor * normalDistance
        fuzz = partitionSize * fuzziness
    }

    func layout(graph: Graph) {
        guard graph.nodes.count > 1 else {
            equilibrium = true
            return
        }
        equilibrium = false
        let stoppedNodes = CGFloat(graph.nodes.filter { !$0.moving || $0.fixed }.count)
        let nodes = CGFloat(graph.nodes.count)
        var energy: CGFloat = 0
        var velocity: CGSize = .zero

//        fuzzing = (fuzzing + 1).truncatingRemainder(dividingBy: 3)
//        let size = partitionSize - fuzz + fuzzing * fuzz

        let crashedNodes = graph.nodes.filter { $0.bounds.isNaN }
        if !crashedNodes.isEmpty {
            speed -= 1
            crashedNodes.forEach {
                $0.position = .random(in: -100 ..< 600)
            }
        }

        for i in graph.nodes.indices {
            let node = graph.nodes[i]
            guard node.moving, !node.fixed else { continue }

            for j in graph.nodes.indices {
                guard i != j else { continue }
                let other = graph.nodes[j]
                let nodePoint = node.bounds.borderPoint(to: other.position)
                let otherPoint = other.bounds.borderPoint(to: node.position)
                let charge = (node.charge + other.charge) / 2
                let distance = nodePoint - otherPoint
                let force = distance.length.square
                let velocity = distance * speed * (charge / force)

                if node.bounds.intersects(other.bounds) {
                    node.velocity -= velocity
                } else {
                    node.velocity += velocity
                }
            }

            for edge in node.links {
                if edge.visible {
                    let nodePoint = node.bounds.borderPoint(to: edge.position)
                    let edgePoint = edge.bounds.borderPoint(to: node.position)
                    let mass = (node.mass + edge.mass) / 2
                    let distance = edgePoint - nodePoint
                    let force = distance.length / CGFloat(edge.links.count)
                    let velocity = distance * speed * (mass * force * attractionConstant)

                    if node.bounds.intersects(edge.bounds) {
                        node.velocity -= velocity
                    } else {
                        node.velocity += velocity
                    }
                }
            }
            node.velocity *= damping

            velocity += node.velocity

            energy += abs(node.velocity.x) + abs(node.velocity.y)
        }

//        print("Velocitydiff: \((velocity - self.velocity).length)")

        if energy < 20, speed < 20 {
            speed += 1
            print("Speed: \(speed)")
        }

        equilibrium = energy < (nodes - stoppedNodes) * stoppingVelocity || (velocity - self.velocity).length < 0.00000001
        self.velocity = velocity
    }
}
