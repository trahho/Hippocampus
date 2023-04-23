//
//  Role.Representation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation

extension Structure {
    class Representation: Object {
        @Persistent var name: String
        @Persistent var presentation: Structure.Presentation

   
    }
}
