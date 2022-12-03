//
//  PersistentGraph.Edge.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Foundation

extension PersistentGraph {
    open class Edge: Member {
        @PublishedSerialized private(set) var from: Node
        @PublishedSerialized private(set) var to: Node
        
        public required init() {}
        
        func connect() {
            from.outgoing.insert(self)
            to.incoming.insert(self)
        }
        
        func disconnect() {
            from.outgoing.remove(self)
            to.incoming.remove(self)
        }
        
        init(from: Node, to: Node) {
            super.init()
            self.from = from
            self.to = to
            connect()
        }
    }
}
