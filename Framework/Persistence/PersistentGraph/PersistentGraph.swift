//
//  PersistentGraph.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

open class PersistentGraph<Role: CodableIdentifiable, Key: CodableIdentifiable>: PersistentContent, ObservableObject {
    // MARK: - Types

    public typealias PersistentValue = Codable & Equatable
    typealias ChangePublisher = PassthroughSubject<Change, Never>

    enum Fault: Error {
        case mergeFailed
    }

    // MARK: - Data

    @Serialized private(set) var nodeStorage: [Item.ID: Node] = [:]
    @Serialized private(set) var edgeStorage: [Item.ID: Edge] = [:]

    let isCurrent: (Item, Date?) -> Bool = { item, timestamp in
        guard !item.isDeleted else { return false }
        guard let timestamp = timestamp else { return true }
        guard item.added <= timestamp else { return false }
        return true
    }

    var nodes: Set<Node> { Set<Node>(nodeStorage.values.filter { isCurrent($0, timestamp) }) }
    var edges: Set<Edge> { Set<Edge>(edgeStorage.values.filter { isCurrent($0, timestamp) }) }

    // MARK: - Publishers

    var objectDidChange = PassthroughSubject<Void, Never>()
    var changeDidHappen: ChangePublisher = .init()

    // MARK: - Initialisation

    public required init() {}

    // MARK: - Restoration

    func setup() -> PersistentGraph {
        self
    }

    func restore() {
        nodeStorage.values.forEach { node in
            node.graph = self
        }
        edgeStorage.values.forEach { edge in
            edge.graph = self
            edge.connect()
        }
    }

    // MARK: - Merging

    func merge(other: PersistentGraph) throws {
        if nodeStorage.isEmpty {
            throw Fault.mergeFailed
        }

        objectWillChange.send()

        Set(edgeStorage.keys).intersection(Set(other.edgeStorage.keys))
            .forEach { key in
                edgeStorage[key]!.merge(other: other.edgeStorage[key]!)
            }

        Set(nodeStorage.keys).intersection(Set(other.nodeStorage.keys))
            .forEach { key in
                nodeStorage[key]!.merge(other: other.nodeStorage[key]!)
            }

        Set(other.edgeStorage.keys).subtracting(Set(edgeStorage.keys))
            .forEach { key in
                let edge = other.edgeStorage[key]!
                edgeStorage[key] = edge
                edge.graph = self
                edge.adopt()
            }

        Set(other.nodeStorage.keys).subtracting(Set(nodeStorage.keys))
            .forEach { key in
                let node = other.nodeStorage[key]!
                nodeStorage[key] = node
                node.graph = self
                node.adopt()
            }
    }

    func purge(timestamp: Date = Date()) {}

    // MARK: - Modification

    public typealias Action = () throws -> Void
    private var transactions: [Transaction] = []

    var changing: Bool {
        !transactions.isEmpty
    }

    var timestamp: Date? {
        transactions.first?.timestamp
    }

    var currentTransaction: Transaction? {
        transactions.last
    }

    func registerTransaction(transaction: Transaction) {
        guard !transactions.contains(where: { $0 === transaction }) else { fatalError("Confused transactions") }

        transactions.append(transaction)
    }

    func unregisterTransaction(transaction: Transaction) {
        guard transaction === currentTransaction else { fatalError("Confused transactions") }

        transactions.removeLast()
        if transactions.isEmpty, transaction.hasChanges {
            objectDidChange.send()
        }
    }

    func discardChanges(transaction: Transaction) {
        guard transaction === currentTransaction else { fatalError("Confused transactions") }

        transaction.changes.forEach { change in
            switch change {
            case let .node(node, _):
                objectWillChange.send()
                nodeStorage.removeValue(forKey: node.id)
            case let .edge(edge, _):
                objectWillChange.send()
                edge.disconnect()
                edgeStorage.removeValue(forKey: edge.id)
            case let .modified(item, key, timestamp):
                item.reset(key, before: timestamp)
            case let .deleted(item, timestamp):
                item.reset(\.deleted, before: timestamp)
            case let .role(item, timestamp):
                item.reset(\.roles, before: timestamp)
            default: break
            }
            changeDidHappen.send(.discarded(change, change.timestamp))
        }
        transaction.changes.removeAll()
    }

    func change(_ action: Action) {
        let transaction = transaction()
        transaction.begin()
        do {
            try action()
            transaction.commit()
        } catch {
            transaction.discard()
        }
    }

    func transaction() -> Transaction {
        Transaction(graph: self)
    }

    func addChange(_ change: Change) {
        changeDidHappen.send(change)
    }

    // MARK: - Function

    func add(_ edge: Edge) {
        guard edgeStorage[edge.id] == nil else { return }
        change {
            guard let timestamp = timestamp else { return }
            objectWillChange.send()
            edge.added = timestamp
            edge.graph = self
            edgeStorage[edge.id] = edge
            edge.adopt()
            addChange(.edge(edge, timestamp))
        }
    }

    func add(_ node: Node) {
        guard nodeStorage[node.id] == nil else { return }
        objectWillChange.send()
        change {
            guard let timestamp = timestamp else { return }
            node.added = timestamp
            node.graph = self
            nodeStorage[node.id] = node
            node.adopt()
            addChange(.node(node, timestamp))
        }
    }
}
