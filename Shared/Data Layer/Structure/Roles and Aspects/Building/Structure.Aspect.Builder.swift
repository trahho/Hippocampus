//
//  Structure.Aspect.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
extension Structure.Aspect {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.Aspect] { [] }

        static func buildBlock(_ aspects: Structure.Aspect...) -> [Structure.Aspect] {
            aspects
        }
    }

    convenience init(_ id: String, _ name: String, _ presentation: Presentation) {
        self.init()
        self.id = UUID(uuidString: id)!
        self.name = name
        self.presentation = presentation
    }
}
