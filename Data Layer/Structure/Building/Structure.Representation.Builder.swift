//
//  Structure.Representation.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.04.23.
//

import Foundation

extension Structure.Representation {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.Representation] { [] }

        static func buildBlock(_ representations: Structure.Representation...) -> [Structure.Representation] {
            representations
        }
    }

    convenience init(_ name: String, _ representation: Structure.Presentation) {
        self.init()
        self.name = name
        self.presentation = representation
    }
}
