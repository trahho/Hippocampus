//
//  PersistentGraph.Node.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

extension PersistentGraph {
    open class Node: Member {
        @Published internal var incomingEdges: Set<Edge> = []
        @Published internal var outgoingEdges: Set<Edge> = []

        var incoming: Set<Edge> { incomingEdges.filter { graph?.isCurrent($0, graph?.timestamp) ?? !$0.isDeleted }}
        var outgoing: Set<Edge> { outgoingEdges.filter { graph?.isCurrent($0, graph?.timestamp) ?? !$0.isDeleted }}

        var edges: Set<Edge> {
            incoming.union(outgoing)
        }

        public required init() {}

        override func adopt() {
            guard let graph else { return }
            objectWillChange.send()
            incomingEdges = incomingEdges.map { edge in
                graph.add(edge)
                return graph.edgeStorage[edge.id]!
            }.asSet
            outgoingEdges = outgoingEdges.map { edge in
                graph.add(edge)
                return graph.edgeStorage[edge.id]!
            }.asSet
        }
    }
}
