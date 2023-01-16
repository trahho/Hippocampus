//
//  Opinion.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation
extension Mind.Opinion {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Mind.Opinion] { [] }

        static func buildBlock(_ opinions: Mind.Opinion...) -> [Mind.Opinion] {
            opinions
        }
    }
}
