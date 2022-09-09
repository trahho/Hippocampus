//
//  Brain.Aspects.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
extension Aspect {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Aspect] { [] }

        static func buildBlock(_ aspects: Aspect...) -> [Aspect] {
            aspects
        }
    }
}
