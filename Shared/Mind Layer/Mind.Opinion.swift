//
//  Brain.thought.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.08.22.
//

import Foundation

extension Mind {
    class Opinion: PersistentData.Object {
        typealias ComparableCodable = Codable & Comparable

//        required init() {}

        func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
            (false, [])
        }
    }
}
