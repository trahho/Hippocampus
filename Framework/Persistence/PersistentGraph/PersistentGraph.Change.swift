//
//  PersistentGraph.Change.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.12.22.
//

import Foundation

extension PersistentGraph {
    indirect enum Change: Equatable {
        case changing(Date)
        case finished(Date)
        case rewinding(Date)
        case discarded(Change, Date)
        case node(Node, Date)
        case edge(Edge, Date)
        case modified(Item, Key, Date)
        case role(Item, Date)
        case deleted(Item, Date)

        var timestamp: Date {
            switch self {
            case let .changing(date):
                return date
            case let .finished(date):
                return date
            case let .rewinding(date):
                return date
            case let .discarded(_, date):
                return date
            case let .node(_, date):
                return date
            case let .edge(_, date):
                return date
            case let .modified(_, _, date):
                return date
            case let .role(_, date):
                return date
            case let .deleted(_, date):
                return date
            }
        }
        
//        func discard(graph: PersistentGraph) {
//            switch self {
//            case let .node(node, timestamp)
//                graph.nodeStorage.removeValue(forKey: node.id)
//            case let .edge(edge):
//                edge.disconnect()
//                edgeStorage.removeValue(forKey: edge.id)
//            case let .modified(item, key, timestamp):
//                item.reset(key, before: timestamp!)
//            case let .deleted(item, timestamp):
//                item.reset(\.deleted, before: timestamp!)
//            case let .role(item, timestamp):
//                item.reset(\.roles, before: timestamp!)
//            default: break
//            }
//        }
    }
}
