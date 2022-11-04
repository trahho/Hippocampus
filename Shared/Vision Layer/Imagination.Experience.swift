//
//  Imagination.Experience.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation

extension Imagination {
    class Experience: PersistentObject, ObservableObject {
        enum Impression {
            case none, list, tree, map, table, grid
        }
        
        @PublishedSerialized var designation: String = ""
        @PublishedSerialized var impression: Impression = .none
        @PublishedSerialized var genes: Genes = .init()
        
        func have(from thought: Mind.Thought) {
            
        }
        
    }
}
