//
//  Role.Representation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation

extension Structure.Role {
    struct Representation: Structure.PersistentValue {
        let name: String
        let representation: Structure.Representation

        init(_ name: String, _ representation: Structure.Representation) {
            self.name = name
            self.representation = representation
        }

        @resultBuilder
        enum Builder {
            static func buildBlock() -> [Structure.Role.Representation] { [] }

            static func buildBlock(_ representations: Structure.Role.Representation...) -> [Structure.Role.Representation] {
                representations
            }
        }
    }
}
