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

//    @Serialized private var storage: [Item.ID: Item] = [:]
    @Serialized private(set) var nodeStorage: [Item.ID: Node] = [:]
    @Serialized private(set) var edgeStorage: [Item.ID: Edge] = [:]

    ////    @Serialized
//    private(set) var edgeStorage: [Item.ID: Edge] {
//        get {
//            Dictionary(uniqueKeysWithValues: storage.values.compactMap { $0 as? Edge }.map { ($0.id, $0) })
//        }
//        set {
//            storage.merge(newValue) { $1 }
//        }
//    }
//
//    private(set) var nodeStorage: [Item.ID: Node]  {
//        get {
//            Dictionary(uniqueKeysWithValues: storage.values.compactMap { $0 as? Node }.map { ($0.id, $0) })
//        }
//        set {
//            storage.merge(newValue) { $1 }
//        }
//    }

//    @Serialized
//    private(set) var nodeStorage: [Item.ID: Node] = [:] {
//        didSet {
//            Set(nodeStorage.keys).subtracting(Set(storage.keys))
//                .forEach { storage[$0] = edgeStorage[$0]! }
//            Set(storage.keys).subtracting(Set(nodeStorage.keys))
//                .forEach { storage.removeValue(forKey: $0) }
//        }
//    }

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
                if let sameEdge = edgeStorage.values.filter({ $0.fromId == edge.fromId && $0.toId == edge.toId }).first {
                    edge.id = sameEdge.id
                    edgeStorage[sameEdge.id]?.merge(other: edge)
                } else {
                    edgeStorage[key] = edge
                    edge.graph = self
                    edge.adopt(timestamp: nil)
                }
            }

        Set(other.nodeStorage.keys).subtracting(Set(nodeStorage.keys))
            .forEach { key in
                let node = other.nodeStorage[key]!
                nodeStorage[key] = node
                node.graph = self
                node.adopt(timestamp: nil)
            }

//        let duplicateStorage = Dictionary(grouping: edgeStorage.values) { $0.from.id.uuidString + "-" + $0.to.id.uuidString }.values.filter { $0.count > 1 }
//        for duplicates in duplicateStorage {
//            let oldest = duplicates.min { $0.added! < $1.added! }!
//            for other in duplicates.filter({ $0 != oldest }) {
//                other.disconnect()
//                edgeStorage.removeValue(forKey: other.id)
//                other.id = oldest.id
//                oldest.merge(other: other)
//            }
//        }
    }

    func purge(timestamp _: Date = Date()) {}

    func publishDidChange() {
        objectDidChange.send()
    }

    // MARK: - Modification

    private(set) var timestamp: Date?

    // MARK: - Function

    @discardableResult func add(_ edge: Edge, timestamp: Date? = nil) -> Edge {
        guard edgeStorage[edge.id] == nil else { return edgeStorage[edge.id]! }
        objectWillChange.send()

        let timestamp = timestamp ?? Date()

        if let sameEdge = edgeStorage.values.filter({ $0.fromId == edge.fromId && $0.toId == edge.toId }).first {
            edge.id = sameEdge.id
            edgeStorage[sameEdge.id]?.merge(other: edge)
        } else {
            if edge.added == nil {
                edge.added = timestamp
            }
            edge.graph = self
            edgeStorage[edge.id] = edge
            edge.adopt(timestamp: timestamp)
        }
        publishDidChange()
        return edgeStorage[edge.id]!
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
