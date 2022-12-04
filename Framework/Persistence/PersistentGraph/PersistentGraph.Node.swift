//
//  PersistentGraph.Node.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

extension PersistentGraph {
    open class Node: Member {
        @Published var incoming: Set<Edge> = []
        @Published var outgoing: Set<Edge> = []

        public required init() {}
    }

   
}
