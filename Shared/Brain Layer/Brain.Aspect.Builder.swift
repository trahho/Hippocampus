//
//  Brain.Aspects.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
extension Brain.Aspect {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Brain.Aspect] { [] }

        static func buildBlock(_ aspects: Brain.Aspect...) -> [Brain.Aspect] {
            aspects
        }
    }
}
