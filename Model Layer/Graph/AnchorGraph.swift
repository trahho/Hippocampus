//
//  AnchorGraph.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.23.
//

import Foundation

class AnchorGraph: Identifiable, ObservableObject {
    enum NodeType {
        case unknown, anchor, knot, attribute, tie, edge, partition

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
            }
        }
    }

    class Node: Identifiable {
        @Published var type: NodeType = .anchor
        @Published var position = CGPoint(x: Int.random(in: 100...800), y: Int.random(in: 100...800))
        var velocity: CGPoint = .zero
        var edges: [Node] = []

        var moving = true
        var unstoppable = false
        var fixed = false
        var visible = true

        var mass: CGFloat {
            type.mass
        }

        var charge: CGFloat {
            type.charge
        }

        func start() {
            moving = true
            edges.forEach { $0.start() }
        }

        func stop() {
            moving = unstoppable
        }
    }

    class Edge: Node {
        var node: Node
        var otherNode: Node

        init(node: Node, otherNode: Node) {
            self.node = node
            self.otherNode = otherNode
            super.init()
            type = .edge
            position = CGRect(firstPoint: node.position, secondPoint: otherNode.position).center
            edges.append(node)
            edges.append(otherNode)
            node.edges.append(self)
            otherNode.edges.append(self)
        }

        override func start() {
            moving = true
        }

        override func stop() {
            moving = node.moving || otherNode.moving
        }
    }

    class Partition: Node {
        var nodes: [Node]
        var _mass: CGFloat
        override var mass: CGFloat { _mass }
        var _charge: CGFloat
        override var charge: CGFloat { _charge }

        init(node: Node) {
            nodes = [node]
            _mass = node.mass
            _charge = node.charge
            super.init()
            position = node.position
        }

        func add(node: Node) {
            position = (position * mass + node.position * node.mass) / (mass + node.mass)
            _mass += node.mass
            _charge += node.charge
            nodes.append(node)
        }
    }

    class LayoutEngine {
        var normalDistance: CGFloat = 20
        var damping: CGFloat = 0.96
        var stoppingVelocity: CGFloat = 0.1
        var minimumStartingVelocity: CGFloat = 1
        var maximumStartingVelocity: CGFloat = 5
        var startingVelocityDelta: CGFloat
        var attractionConstant: CGFloat
        var partitionFactor: CGFloat = 15
        var stiffness: CGFloat = 1
        var equilibrium = false
        var partitions: [CGPoint: Partition] = [:]
        var partitionSize: CGFloat
        var longRangeEffect: CGFloat = 0.25
        var fuzziness: CGFloat = 0.1
        var fuzz: CGFloat
        var fuzzing: CGFloat = 0

        init() {
            attractionConstant = 1 / normalDistance / normalDistance / normalDistance
            partitionSize = partitionFactor * normalDistance
            startingVelocityDelta = maximumStartingVelocity - minimumStartingVelocity
            fuzz = partitionSize * fuzziness
        }

        func repelling(node: Node, otherNode: Node) -> CGSize {
            let charge = (node.charge + otherNode.charge) / 2
            let size = (node.position - otherNode.position)
            let distance = (node.position - otherNode.position).length
            return charge * size / distance.square
        }

        func attracting(node: Node, otherNode: Node) -> CGSize {
            let mass = (node.mass + otherNode.mass) / 2
            let size = (otherNode.position - node.position)
            let distance = (node.position - otherNode.position).length
            return attractionConstant * mass * size / distance
        }

        func layout(nodes: [Node]) {
            equilibrium = false

            let numberOfNodes: CGFloat = CGFloat(nodes.count)
            var numberOfStoppedNodes: CGFloat = 0

            // set up partitions
            partitions = [:]
            fuzzing = (fuzzing + 1).truncatingRemainder(dividingBy: 3)

            let size = partitionSize - fuzz + fuzzing * fuzz
            for node in nodes {
                if !node.moving || node.fixed {
                    numberOfStoppedNodes += 1
                }
                let key = (node.position / size).rounded(.down)
                if let partition = partitions[key] {
                    partition.add(node: node)
                } else {
                    partitions[key] = Partition(node: node)
                }
            }

            // calculate the velocity of the partitions
            for partition in partitions.values {
                for otherPartition in partitions.values {
                    guard partition.id != otherPartition.id else { continue }
                    partition.velocity += repelling(node: partition, otherNode: otherPartition)
                }
            }

            var energy: CGFloat = 0
            for partition in partitions.values {
                for node in partition.nodes {
                    // add the long range effect from other partitions, somewhat weakened
                    node.velocity += longRangeEffect * partition.velocity
                    for otherNode in partition.nodes {
                        guard node.id != otherNode.id else { continue }
                        // for nodes in the same partition add the repelling velocity
                        node.velocity += repelling(node: node, otherNode: otherNode)
                    }

                    // for edges apply bending force (straightens out edges)

                    if let edge = node as? Edge, edge.otherNode.visible, edge.node.visible {
                        // update the control point
                        let controlpoint = CGRect(firstPoint: edge.node.position, secondPoint: edge.otherNode.position).controlPoint(for: edge.position)

                        // curvature is higher for a very bent edge (nodes close together)
                        let curvature = stiffness / (edge.node.position - edge.otherNode.position).length
                        // attract the edge mid point to the control point
                        node.velocity -= curvature * (controlpoint - edge.position)
                    }
                    // for nodes, add the attracting velocity from all edges
                    for edge in node.edges {
                        if edge.visible {
                            node.velocity += attracting(node: node, otherNode: edge) / CGFloat(node.edges.count)
                        }
                    }
                    // apply damping
                    node.velocity *= damping
                    let velocity = abs(node.velocity.x) + abs(node.velocity.y)
                    // check to see if the node has stopped moving
                    if velocity <= stoppingVelocity {
                        node.stop()
                        node.velocity = .zero
                    } else if velocity >= minimumStartingVelocity + startingVelocityDelta * numberOfStoppedNodes / numberOfNodes {
                        // the more nodes that have stopped, the larger the starting velocity must be
                        node.start()
                    }
                    // if the node is moving and not fixed then calculate the new position
                    if node.moving && !node.fixed {
                        energy += velocity
                        node.position += node.velocity
                    }
                }
            }
            if energy < (numberOfNodes - numberOfStoppedNodes) * stoppingVelocity {
                equilibrium = true
            }
        }
    }

    @Published var nodes: [Node] = []
    var edges: [Edge] {
        nodes.compactMap { $0 as? Edge }
    }

    var layouter: LayoutEngine = LayoutEngine()

  
    func startLayout() {
//        guard !isLayouting else { return }

        print("Layout started")

        nodes.forEach {
            $0.velocity = .zero
            $0.moving = true
        }
        layouter.equilibrium = false
        doLayout()
    }


    func doLayout() {
        guard  !layouter.equilibrium else {
            return
        }
        objectWillChange.send()
        layouter.layout(nodes: self.nodes)

        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(1))) {
            self.doLayout()
        }
    }

    func stopLayout() {
//        isLayouting = false
        print("Layout stopped")
    }

    deinit {
        print("Deinit")
    }
}
