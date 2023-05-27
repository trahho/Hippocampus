//
//  MyComplexSprintLayouter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.05.23.
//

import Foundation

extension MyComplexSpringLayouter {
    struct Partition {
        var charge: CGFloat = .zero
        var mass: CGFloat = .zero
        var bounds: CGRect = .null
        var position: CGPoint = .zero
        var nodes: [Graph.Node] = []
        var velocity: CGPoint = .zero

        mutating func addVelocity(_ velocity: CGSize) {
            self.velocity += velocity
        }
    }
}

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

        fuzzing = (fuzzing + 1).truncatingRemainder(dividingBy: 3)
        let size = partitionSize - fuzz + fuzzing * fuzz

        let crashedNodes = graph.nodes.filter { $0.bounds.isNaN }
        if !crashedNodes.isEmpty {
            speed -= 1
            crashedNodes.forEach {
                $0.position = .random(in: -100 ..< 600)
            }
        }
        let partitions = Dictionary(grouping: graph.nodes, by: { ($0.position / CGFloat.infinity).rounded(.down) })
//        var partitions = Dictionary(grouping: graph.nodes, by: { CGPoint.zero })
            .values
            .map { nodes in
                nodes.reduce(into: Partition(nodes: nodes)) { partition, node in
                    partition.bounds = partition.bounds.isNull ? node.bounds : partition.bounds.union(node.bounds)
                    partition.position = (partition.position * partition.mass + node.position * node.mass) / (partition.mass + node.mass)
                    partition.charge += node.charge
                    partition.mass += node.mass
                }
            }

        for i in partitions.indices {
            var partition = partitions[i]
            for j in partitions.indices {
                guard i != j else { continue }
                let other = partitions[j]
                let nodes = CGFloat(other.nodes.count)
                let partitionPoint = partition.bounds.borderPoint(to: other.position)
                let otherPoint = other.bounds.borderPoint(to: partition.position)
                let charge = nodes * ((partition.charge + other.charge) / 2)
                let distance = partitionPoint - otherPoint
                let force = distance.length.square

                partition.addVelocity(distance * speed * (charge / force))
            }
        }

        for partition in partitions {
            for i in partition.nodes.indices {
                let node = partition.nodes[i]
                guard node.moving, !node.fixed else { continue }
                node.velocity += longRangeEffect * partition.velocity

                for j in partition.nodes.indices {
                    guard i != j else { continue }
                    let other = partition.nodes[j]
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

//                if let edge = node as? Graph.Edge {
//                    if edge.to.visible, edge.from.visible {
//                        let nodePoint = edge.from.bounds.borderPoint(to: edge.position)
//                        let edgePoint = edge.to.bounds.padding(20).borderPoint(to: edge.position)
//                        let curvature = stiffness / (nodePoint - edgePoint).length
//                        let controlPoint = CGRect(firstPoint: nodePoint, secondPoint: edgePoint).controlPoint(for: edge.position)
//                        edge.velocity -= curvature * (controlPoint - edge.position)
//                    }
//                }

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
        }

        print("Velocity: \(velocity)")
        
        if energy < 20, speed < 20 {
            speed += 1
            print("Speed: \(speed)")
        }

        equilibrium = energy < (nodes - stoppedNodes) * stoppingVelocity  || velocity.length > 2
    }
}
