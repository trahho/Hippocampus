//
//  Brain.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation
import SwiftUI

extension Brain {
    class Aspect: Serializable, ObservableObject, IdentifiableObject {
        typealias ID = Int64

        @Serialized var id: ID = 0
        @PublishedSerialized var designation: String = ""
        @PublishedSerialized var representation: Representation
        @PublishedSerialized var defaultValue: Codable?

        init(_ designation: String, _ representation: Representation, defaultValue: Codable? = nil) {
            self.designation = designation
            self.representation = representation
            self.defaultValue = defaultValue
        }

        required init() {}
    }
}

extension Brain.Aspect {
    enum Representation {
        case text, drawing
    }
}

//extension Dictionary where Self.Key == Brain.Aspect.ID, Self.Value == Codable {
//    
//}

// TODO: Collection von Frames, welche die Werte repräsentieren können. Frame kann einen davon wählen. Über Id.
