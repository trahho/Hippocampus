//
//  PersistentGraph.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation
import Combine

open class PersistentGraph<Role: CodableIdentifiable, Key: CodableIdentifiable>: PersistentContent, ObservableObject {
    public typealias Transaction = () throws -> ()
    public typealias PersistentValue = (any Codable)?
    typealias ChangePublisher = PassthroughSubject<Change, Never>


    @Serialized private var idCounter: Member.ID = 0
    @Serialized private(set) var nodes: [Member.ID: Node] = [:]
    @Serialized private(set) var edges: [Member.ID: Edge] = [:]

    var objectDidChange = PassthroughSubject<Void,Never>()
    var changeDidHappen:  ChangePublisher = .init()
    
    public required init() {}

    func restore() {
        nodes.values.forEach { node in
            node.graph = self
        }
        edges.values.forEach { edge in
            edge.graph = self
            edge.connect()
        }
    }

    private(set) var timestamp: Date?
    private(set) var changing = false

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
                nodes.removeValue(forKey: node.id)
                changeDidHappen.send(.discarded(change))
            case let .edge(edge):
                edge.disconnect()
                edges.removeValue(forKey: edge.id)
                changeDidHappen.send(.discarded(change))
            case let .modified(member, key, timestamp):
                member.rewind(key, to: timestamp)
                changeDidHappen.send(.discarded(change))
            default: break
            }
        }
        changes = []
    }

    private var changes: [Change] = []

    func addChange(_ change: Change) {
        changes.append(change)
        changeDidHappen.send(change)
    }
}
