//
//  PersistentGraph.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

open class PersistentGraph<Role: CodableIdentifiable, Key: CodableIdentifiable, Storage: TimedValueStorage>: PersistentContent, Serializable, ObservableObject {
    // MARK: - Types

    public typealias PersistentValue = TimedValueStorage.PersistentValue
//    typealias ChangePublisher = PassthroughSubject<Change, Never>

    enum Fault: Error {
        case mergeFailed
    }

    // MARK: - Data

    @Serialized private(set) var nodeStorage: [Item.ID: Node] = [:]
    @Serialized private(set) var edgeStorage: [Item.ID: Edge] = [:]

    var nodes: Set<Node> { Set<Node>(nodeStorage.values.filter(\.isActive)) }
    var edges: Set<Edge> { Set<Edge>(edgeStorage.values.filter(\.isActive)) }

    public var objectDidChange: ObjectDidChangePublisher = .init()

    // MARK: - Initialisation

    public required init() {}

    // MARK: - Persistence

    public func setup() -> PersistentGraph {
        self
    }

    public func restore() {
        nodeStorage.values.forEach { node in
            node.graph = self
        }
        edgeStorage.values.forEach { edge in
            edge.graph = self
            edge.connect()
        }
    }

    public func merge(other: PersistentGraph) throws {
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
                edge.adopt(timestamp: nil)
            }

        Set(other.nodeStorage.keys).subtracting(Set(nodeStorage.keys))
            .forEach { key in
                let node = other.nodeStorage[key]!
                nodeStorage[key] = node
                node.graph = self
                node.adopt(timestamp: nil)
            }
    }

    func purge(timestamp _: Date = Date()) {}

    func publishDidChange() {
        objectDidChange.send()
    }

    // MARK: - Modification

    private(set) var timestamp: Date?

    // MARK: - Function

    func add(_ edge: Edge, timestamp: Date? = nil) {
        guard edgeStorage[edge.id] == nil else { return }
        objectWillChange.send()

        let timestamp = timestamp ?? Date()

        if edge.added == nil {
            edge.added = timestamp
        }
        edge.graph = self
        edgeStorage[edge.id] = edge
        edge.adopt(timestamp: timestamp)
        publishDidChange()
    }

    func add(_ node: Node, timestamp: Date? = nil) {
        guard nodeStorage[node.id] == nil else { return }
        objectWillChange.send()

        let timestamp = timestamp ?? Date()

        if node.added == nil {
            node.added = timestamp
        }
        node.graph = self
        nodeStorage[node.id] = node
        node.adopt(timestamp: timestamp)
        publishDidChange()
    }
}
