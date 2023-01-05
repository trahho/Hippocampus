//
//  PersistentGraph.Transaction.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.01.23.
//

import Foundation
import Combine

public extension PersistentGraph {
    class Transaction {
        var graph: PersistentGraph
        var timestamp: Date?
        var previoustimestamp: Date?
        var changeObserver: AnyCancellable?
        var changes: [Change] = []

        var isActive: Bool {
            timestamp != nil
        }
        
        var hasChanges: Bool{
            !changes.isEmpty
        }

        init(graph: PersistentGraph) {
            self.graph = graph
        }

        public func begin() {
            guard timestamp == nil else { return }
            timestamp = Date()
            connect()
            graph.changeDidHappen.send(.changing(timestamp!))
//            print("Transaction \(timestamp!) begins")
        }

        public func discard() {
            guard let timestamp, graph.currentTransaction === self else { fatalError("Confused transactions") }
//            print("Transaction \(timestamp) discards")

            graph.discardChanges(transaction: self)
            
            graph.changeDidHappen.send(.finished(timestamp))
            disconnect()
            self.timestamp = nil
        }

        public func commit() {
            guard let timestamp, graph.currentTransaction === self else { fatalError("Confused transactions") }
            graph.changeDidHappen.send(.finished(timestamp))
            disconnect()
//            print("Transaction \(timestamp) commits")
            self.timestamp = nil
        }

        private func disconnect() {
            guard graph.currentTransaction === self else {
                fatalError("Confused transactions")
            }
            changeObserver!.cancel()
            graph.unregisterTransaction(transaction: self)
        }

        private func connect() {
            guard let timestamp, !(graph.currentTransaction === self) else {
                fatalError("Confused transactions")
            }
            graph.registerTransaction(transaction: self)
            changeObserver = graph.changeDidHappen.sink { [self] change in
                if change.timestamp >= timestamp {
                    changes.append(change)
                }
            }
        }
    }
}
