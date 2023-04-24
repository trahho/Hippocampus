//
//  PersistentGraph.Edge.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Foundation

extension PersistentGraph {
    open class Edge: Item {
        @PublishedSerialized private(set) var fromId: Node.ID
        @PublishedSerialized private(set) var toId: Node.ID

        private var _from: Node?
        var from: Node {
            get {
                if let _from { return _from }
                guard let graph else { fatalError("No graph, no from") }
                _from = graph.nodeStorage[fromId]
                return _from!
            }
            set {
                _from = newValue
                fromId = newValue.id
            }
        }

        private var _to: Node?
        var to: Node {
            get {
                if let _to { return _to }
                guard let graph else { fatalError("No graph, no to") }
                _to = graph.nodeStorage[toId]
                return _to!
            }
            set {
                _to = newValue
                toId = newValue.id
            }
        }

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

        override func adopt(timestamp: Date?) {
            guard let graph else { return }
            objectWillChange.send()
            disconnect()
            graph.add(from, timestamp: timestamp)
            graph.add(to, timestamp: timestamp)
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
