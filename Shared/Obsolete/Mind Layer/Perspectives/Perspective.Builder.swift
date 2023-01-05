//
//  Brain.Perspective.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
extension Perspective {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Perspective] { [] }

        static func buildBlock(_ perspectives: Perspective...) -> [Perspective] {
            perspectives
        }
    }
}
