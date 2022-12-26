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

    public typealias Transaction = () throws -> Void
    public typealias PersistentValue = Codable & Equatable
    typealias ChangePublisher = PassthroughSubject<Change, Never>

    enum Fault: Error {
        case mergeFailed
    }

    // MARK: - Data

    @Serialized private(set) var nodeStorage: [Member.ID: Node] = [:]
    @Serialized private(set) var edgeStorage: [Member.ID: Edge] = [:]

    let isCurrent: (Member, Date?) -> Bool = { member, timestamp in
        guard !member.isDeleted else { return false }
        guard let timestamp = timestamp else { return true }
        guard member.added <= timestamp else { return false }
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
                add(other.edgeStorage[key]!)
            }
        
        Set(other.nodeStorage.keys).subtracting(Set(nodeStorage.keys))
            .forEach { key in
                add(other.nodeStorage[key]!)
            }
    }

    func purge(timestamp: Date = Date()) {}

    // MARK: - Modification

    private(set) var timestamp: Date?
    private(set) var changing = false
    private var changes: [Change] = []

    func change(_ transaction: Transaction) {
        let hasStarted = !changing
        change()
        do {
            try transaction()
        } catch {
            discardChange()
        }
        if hasStarted {
            finish()
        }
    }

    func change() {
        guard !changing else { return }
        rewind(timestamp: Date())
        changing = true
        changeDidHappen.send(.changing)
    }

    func rewind(timestamp: Date) {
        guard !changing, timestamp <= Date() else { return }
        objectWillChange.send()
        changing = false
        self.timestamp = timestamp
        changeDidHappen.send(.rewinding(timestamp))
    }

    func finish() {
        guard timestamp != nil else { return }
        objectWillChange.send()
        if changing, !changes.isEmpty {
            objectDidChange.send()
        }
        changing = false
        timestamp = nil
        changes = []
        changeDidHappen.send(.finished)
    }

    func discardChange() {
        guard changing else { return }
        for change in changes {
            switch change {
            case let .node(node):
                nodeStorage.removeValue(forKey: node.id)
            case let .edge(edge):
                edge.disconnect()
                edgeStorage.removeValue(forKey: edge.id)
            case let .modified(member, key, timestamp):
                member.reset(key, before: timestamp!)
            case let .deleted(member, timestamp):
                member.reset(\.deleted, before: timestamp!)
            case let .role(member, timestamp):
                member.reset(\.roles, before: timestamp!)
            default: break
            }
            changeDidHappen.send(.discarded(change))
        }
        changes = []
    }

    func addChange(_ change: Change) {
        changes.append(change)
        changeDidHappen.send(change)
    }

    // MARK: - Function

    func add(_ edge: Edge) {
        guard changing, let timestamp = timestamp, edgeStorage[edge.id] == nil else { return }

        edge.added = timestamp
        edge.graph = self
        edgeStorage[edge.id] = edge
        edge.adopt()
    }

    func add(_ node: Node) {
        guard changing, let timestamp = timestamp, nodeStorage[node.id] == nil else { return }
        node.added = timestamp
        node.graph = self
        nodeStorage[node.id] = node
        node.adopt()
    }
}
