//
//  Thing.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.09.22.
//

import Foundation

extension Mind {
    class Thing: IdentifiableObject, AspectStorage {
        var brain: Brain
        var information: Brain.Information
        
        let perspectives: Set<Perspective>
        
        init(brain: Brain, information: Brain.Information, perspectives: Set<Perspective>) {
            self.brain = brain
            self.information = information
            self.perspectives = perspectives
        }
        
        subscript(id: Aspect.ID) -> Codable? {
            get {
                information[id]
            }
            set {
                information[id] = newValue
            }
        }
        
        override var id: IdentifiableObject.ID {
            get {
                return information.id
            }
            set {}
        }
        
        func takesPerspective(_ id: Perspective.ID) -> Bool {
            perspectives.contains { $0.id == id }
        }
        
        func takePerspective(_ id: Perspective.ID) {}
    }
}
