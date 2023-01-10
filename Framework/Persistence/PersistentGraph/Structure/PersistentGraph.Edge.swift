//
//  PersistentGraph.Edge.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Foundation

extension PersistentGraph {
    open class Edge: Item {
        @PublishedSerialized private(set) var from: Node
        @PublishedSerialized private(set) var to: Node
        
        public required init() {}
        
        func getOther(for node: Node) -> Node {
            node == from ? to : from
        }
        
        func connect() {
            from.outgoingEdges.insert(self)
            to.incomingEdges.insert(self)
        }
        
        func disconnect() {
            from.outgoingEdges.remove(self)
            to.incomingEdges.remove(self)
        }
        
        override func adopt(changeManager: ChangeManager) {
            guard let graph else { return }
            objectWillChange.send()
            disconnect()
            graph.add(from, changeManager: changeManager)
            graph.add(to, changeManager: changeManager)
            from = graph.nodeStorage[from.id]!
            to = graph.nodeStorage[to.id]!
            connect()
        }
        
        init(from: Node, to: Node) {
            super.init()
            self.from = from
            self.to = to
            connect()
        }
    }
}
