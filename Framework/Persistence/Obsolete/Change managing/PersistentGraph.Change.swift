////
////  PersistentGraph.Change.swift
////  Hippocampus
////
////  Created by Guido Kühn on 04.12.22.
////
//
//import Foundation
//
//extension PersistentGraph {
//    indirect enum Change {
//        case node(Node)
//        case edge(Edge)
//        case modified(Item, Key, TimedValue)
//        case role(Item, TimedValue)
//        case deleted(Item, TimedValue)
//
//        func redo(graph: PersistentGraph) {}
//
//        func undo(graph: PersistentGraph) {}
//
////        func discard(graph: PersistentGraph) {
////            switch self {
////            case let .node(node, timestamp)
////                graph.nodeStorage.removeValue(forKey: node.id)
////            case let .edge(edge):
////                edge.disconnect()
////                edgeStorage.removeValue(forKey: edge.id)
////            case let .modified(item, key, timestamp):
////                item.reset(key, before: timestamp!)
////            case let .deleted(item, timestamp):
////                item.reset(\.deleted, before: timestamp!)
////            case let .role(item, timestamp):
////                item.reset(\.roles, before: timestamp!)
////            default: break
////            }
////        }
//    }
//}
