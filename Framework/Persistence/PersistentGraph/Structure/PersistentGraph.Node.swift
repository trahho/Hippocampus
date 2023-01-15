//
//  PersistentGraph.Node.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

extension PersistentGraph {
    open class Node: Item {
        @Published internal var incomingEdges: Set<Edge> = []
        @Published internal var outgoingEdges: Set<Edge> = []

        var incoming: Set<Edge> { incomingEdges.filter { $0.isActive }}
        var outgoing: Set<Edge> { outgoingEdges.filter { $0.isActive }}

        var edges: Set<Edge> {
            incoming.union(outgoing)
        }

        public required init() {}

        override func adopt(timestamp: Date?) {
            guard let graph else { return }
            objectWillChange.send()
            incomingEdges = incomingEdges.map { edge in
                graph.add(edge, timestamp: timestamp)
                return graph.edgeStorage[edge.id]!
            }.asSet
            outgoingEdges = outgoingEdges.map { edge in
                graph.add(edge, timestamp: timestamp)
                return graph.edgeStorage[edge.id]!
            }.asSet
        }
    }
}
