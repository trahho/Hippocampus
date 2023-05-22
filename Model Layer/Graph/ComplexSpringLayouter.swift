//
//  ComplexSpringLayouter.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.23.
//

import Foundation

class ComplexSpringLayouter: GraphLayouter {
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

    init() {
        attractionConstant = 1 / (normalDistance * normalDistance * normalDistance)
        startingVelocityDelta = maximumStartingVelocity - minimumStartingVelocity
        partitionSize = partitionFactor * normalDistance
        fuzz = partitionSize * fuzziness
    }

    struct Partition {
        var nodes: [Graph.Node] = []

        var position: CGPoint = .zero
        var velocity: CGPoint = .zero
        var bounds: CGRect
        var mass: CGFloat = 0
        var charge: CGFloat = 0

        init(node: Graph.Node) {
            bounds = CGRect(center: node.position, size: .zero)
            position = node.position
            add(node: node)
        }

        mutating func add(node: Graph.Node) {
            nodes.append(node)
            position = (position * mass + node.position * node.mass) / (mass + node.mass)
            bounds = bounds.union(CGRect(center: node.position, size: .zero))
            mass += node.mass
            charge += node.charge
        }

        mutating func addVelocity(_ velocity: CGPoint) {
            self.velocity += velocity
        }
    }

    func repelling(point: CGPoint, charge: CGFloat, otherPoint: CGPoint, otherCharge: CGFloat) -> CGPoint {
        CGPoint((charge + otherCharge) / 2 *
            (point - otherPoint) /
            (point - otherPoint).length.square)
    }

    func repelling(node: Graph.Node, other: Graph.Node) -> CGPoint {
        let nodePoint = node.position // node.bounds.borderPoint(to: other.position)
        let otherPoint = other.position // other.bounds.borderPoint(to: node.position)
        let repelling = (node.charge + other.charge) / 2 *
            (nodePoint - otherPoint) /
            (nodePoint - otherPoint).length.square

        if node.bounds.intersects(other.bounds) {
            return CGPoint.zero - (node.fixed ? .zero : repelling)
        } else {
            return node.fixed ? CGPoint.zero : CGPoint(repelling)
        }
    }

    func attracting(node: Graph.Node, other: Graph.Node) -> CGPoint {
        let nodePoint = node.bounds.borderPoint(to: other.position)
        let otherPoint = other.bounds.borderPoint(to: node.position)
        let attracting = (node.mass + other.mass) / 2 * attractionConstant *
            (nodePoint - otherPoint) /
            (nodePoint - otherPoint).length

//        if node.bounds.intersects(other.bounds) {
//            return CGPoint.zero - (node.fixed ? .zero : attracting)
//        } else {
        return node.fixed ? CGPoint.zero : CGPoint(attracting)
//        }
    }

    func layout(graph: Graph) {
        var stoppedNodes = 0
        var energy: Double = 0

        fuzzing = (fuzzing + 1).truncatingRemainder(dividingBy: 3)
        let size = partitionSize - fuzz + fuzzing * fuzz
        var partitions: [CGPoint: Partition] = [:]

        for node in graph.nodes {
            if !node.moving || node.fixed {
                stoppedNodes += 1
            }
            let key = (node.position / size).rounded(.down)
            if var partition = partitions[key] {
                partition.add(node: node)
            } else {
                partitions[key] = Partition(node: node)
            }
        }

        for partition in partitions {
            for other in partitions {
                guard partition.key != other.key else { continue }

                let charge = CGFloat(other.value.nodes.count) * ((partition.value.charge + other.value.charge) / 2)
                let force = (partition.value.position - other.value.position).length.square
                let distance = partition.value.position - other.value.position

                partitions[partition.key]!.addVelocity(CGPoint((charge * distance) / force))
            }
        }

        for partition in partitions.values {
            for node in partition.nodes {
                node.velocity += longRangeEffect * partition.velocity

                for otherNode in partition.nodes {
                    guard node != otherNode else { continue }
                    node.velocity += repelling(node: node, other: otherNode)
                }

                if let edge = node as? Graph.Edge {
                    if edge.to.visible, edge.from.visible {
                        let start = edge.from.bounds.borderPoint(to: edge.position)
                        let end = edge.to.bounds.padding(20).borderPoint(to: edge.position)
                        let curvature = stiffness / (start - end).length
                        let controlPoint = CGRect(firstPoint: start, secondPoint: end).controlPoint(for: edge.position)
                        edge.velocity -= curvature * (controlPoint - edge.position)
                    }
                }

                for edge in node.links {
                    if edge.visible {
                        node.velocity += attracting(node: node, other: edge) / edge.links.count
                    }
                }

                node.velocity *= damping

                let velocity = abs(node.velocity.x) + abs(node.velocity.y)
                if velocity <= stoppingVelocity {
                    node.stop()
                    node.velocity = .zero
                } else if velocity > minimumStartingVelocity + startingVelocityDelta * CGFloat(stoppedNodes) / CGFloat(graph.nodes.count) {
                    node.start()
                }

                if node.moving && !node.fixed {
                    energy += velocity
                }
            }
        }

        if energy < Double(graph.nodes.count - stoppedNodes) * stoppingVelocity {
//            graph.stopLayout()
        }
    }
}
