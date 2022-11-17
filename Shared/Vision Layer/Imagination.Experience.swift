//
//  Imagination.Experience.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation

extension Imagination {
    class Experience: PersistentObject, ObservableObject {
        
        struct Attention {
            	
        }
        
        enum Impression {
            case none, list, tree, map, table, grid
        }
        
        enum Focus: Codable {
            case none
            case order(Aspect.ID, SortOrder)

        }
        
        @PublishedSerialized var designation: String = ""
        @PublishedSerialized var impression: Impression = .none
        @PublishedSerialized var focus: Focus = .none
        @PublishedSerialized var genes: Genes = .init()
        
        convenience init(id: ID, _ designation: String, _ impression: Impression) {
            self.init()
            self.id = id
            self.designation = designation
            self.impression = impression
        }
        
        func have(from thought: Mind.Thought) {}
    }
}
