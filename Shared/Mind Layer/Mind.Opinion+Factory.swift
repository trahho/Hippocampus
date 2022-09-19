//
//  Mind.Opinion+Factory.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.09.22.
//

import Foundation

extension Mind.Opinion {
    static func always(_ truth: Bool) -> Mind.Opinion {
        Always(right: truth)
    }

    static func wrong(_ opinion: Mind.Opinion) -> Mind.Opinion {
        AboutOne.Wrong(opinion)
    }

    static func first(_ opinions: Mind.Opinion...) -> Mind.Opinion {
        AboutMany.First(opinions)
    }

    static func aspectValueIs<T: ComparableCodable>(_ aspect: Aspect, _ comparison: AspectValueComparison<T>.Comparison, _ value: T) -> Mind.Opinion {
        AspectValueComparison<T>(aspect: aspect, comparison: comparison, value: value)
    }

    static func takesPerspective(_ perspective: Perspective) -> Mind.Opinion {
        TakesPerspective(perspective: perspective)
    }
}
