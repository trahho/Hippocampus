//
//  Structure.Role.Reference.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation

extension Structure.Reference {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.Reference] { [] }

        static func buildBlock(_ references: Structure.Reference...) -> [Structure.Reference] {
            references
        }
    }

    convenience init(_ to: Structure.Role, _ role: Structure.Role? = nil) {
        self.init()
        self.to = to
        self.role = role
    }
}
