//
//  Brain.Perspective.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
extension Brain.Perspective {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Brain.Perspective] { [] }

        static func buildBlock(_ perspectives: Brain.Perspective...) -> [Brain.Perspective] {
            perspectives
        }
    }
}
