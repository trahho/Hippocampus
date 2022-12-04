//
//  PersistentGraph.Change.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.12.22.
//

import Foundation

extension PersistentGraph {
    indirect enum Change {
        case changing 
        case finished
        case rewinding (Date)
        case discarded(Change)
        case node(Node)
        case edge(Edge)
        case modified(Member, Key, Date)
    }
}
