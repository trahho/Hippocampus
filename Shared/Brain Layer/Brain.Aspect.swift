//
//  Brain.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Aspect: Serializable, ObservableObject, IdentifiableObject {
        typealias ID = Int64
        
        @Serialized var id: ID = 0
        @PublishedSerialized var designation: String = ""
        @PublishedSerialized var representation: Representation

        init( _ designation: String, _ representation: Representation) {
            self.designation = designation
            self.representation = representation
        }

        required init() {}
    }
}

extension Brain.Aspect {
    enum Representation {
        case text, drawing
    }
}

// TODO: Collection von Frames, welche die Werte repräsentieren können. Frame kann einen davon wählen. Über Id.
