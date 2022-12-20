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

        var incoming: Set<Edge> { incomingEdges.filter { !$0.isDeleted }}
        var outgoing: Set<Edge> { outgoingEdges.filter { !$0.isDeleted }}

        var edges: Set<Edge> {
            incoming.union(outgoing).filter { !$0.isDeleted }
        }

        public required init() {}
    }
}
