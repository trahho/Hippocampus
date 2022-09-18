//
//  Brain.Aspects.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation

protocol AspectProducer {
    func buildAspects() -> [Aspect]
}

extension Aspect: AspectProducer {
    func buildAspects() -> [Aspect] {
        [self]
    }
}

extension Perspective: AspectProducer {
    func buildAspects() -> [Aspect] {
        aspects
    }
}

extension Aspect {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Aspect] { [] }

        static func buildBlock(_ producers: AspectProducer...) -> [Aspect] {
            let perspectives = producers.filter { $0 is Perspective }
            let aspects = producers.filter { $0 is Aspect }
            return perspectives.flatMap { $0.buildAspects() }.asSet.asArray + aspects.flatMap { $0.buildAspects() }
        }

//        static func buildBlock(_ perspectives: Perspective..., _ aspects: Aspect...) -> [Aspect] {
//            perspectives.flatMap { $0.aspects }.asSet.asArray + aspects
//        }
    }
}
