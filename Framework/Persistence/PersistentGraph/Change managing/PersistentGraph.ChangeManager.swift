//
//  PersistentGraph.ChangeManager.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.01.23.
//

import Foundation

extension PersistentGraph {
    typealias ChangeBuilder = (TimedValue) -> PersistentGraph.Change
    typealias Action = () -> ()
    
    public class ChangeManager {
        class Changes {
            var title: String = ""
            var changes: [PersistentGraph.Change] = []
        }
        
        var _timestamp: Date?
        
        var timestamp: Date {
            _timestamp ?? Date()
        }
        
        var actions: Int = 0
        var graph: PersistentGraph
        
        var undoable: [Changes] = []
        var redoable: [Changes] = []
        
        var isBlocked: Bool {
            graph.timestamp != nil
        }
        
        init(graph: PersistentGraph) {
            self.graph = graph
        }
        
        func addChange(_ change: Change) {
            if undoable.isEmpty {
                undoable.append(Changes())
            }
            undoable.last!.changes.append(change)
            redoable = []
        }
        
        func finish(title: String) {
            guard !undoable.isEmpty else {
                return
            }
            undoable.last!.title = title
            finish()
        }
        
        func finish() {
            guard !undoable.isEmpty else {
                return
            }
            undoable.append(Changes())
            graph.objectDidChange.send()
        }
        
        func action(title: String? = nil, action: Action) {
            actions += 1
            action()
            actions -= 1
            if let title {
                undoable.last!.title = title
            }
            if actions == 0 {
                finish()
            }
        }
        
        func undo() {
            guard !undoable.isEmpty else {
                return
            }
            let changes = undoable.removeLast()
            redoable.append(changes)
        }
        
        func redo() {
            guard !redoable.isEmpty else {
                return
            }
            let changes = redoable.removeLast()
            undoable.append(changes)
        }
    }
}
