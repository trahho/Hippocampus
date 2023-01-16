//
//  Mind.Opinion+Basics.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.09.22.
//

import Foundation

extension Mind.Opinion {
    class Always: Mind.Opinion {
        @Serialized var right: Bool

        required init() {}

        init(right: Bool) {
            super.init()
            self.right = right
        }

        override func take(for _: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
            return (right, [])
        }
    }

    class TakesPerspective: Mind.Opinion {
        @Serialized var perspective: Perspective

        required init() {}

        init(perspective: Perspective) {
            super.init()
            self.perspective = perspective
        }

        override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
            information.takesPerspective(perspective) ? (true, [perspective]) : (false, [])
        }
    }

    class AspectValueComparison: Mind.Opinion {
        enum Comparison {
            case below, above, equal, unequal
        }

        @Serialized var aspect: Aspect
        @Serialized var value: Aspect.Point
        @Serialized var comparison: Comparison

        required init() {}

        init(aspect: Aspect, comparison: Comparison, value: Aspect.Point) {
            super.init()
            self.aspect = aspect
            self.comparison = comparison
            self.value = value
        }

        override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
            let aspectValue = aspect[information]
            switch comparison {
            case .below:
                guard information.takesPerspective(aspect.perspective), value != .empty, aspectValue == .empty || aspectValue < value else {
                    return (false, [])
                }
                return (true, [aspect.perspective])
            case .above:
                guard information.takesPerspective(aspect.perspective), aspectValue != .empty, value == .empty || aspectValue > value else {
                    return (false, [])
                }
                return (true, [aspect.perspective])
            case .equal:
                guard information.takesPerspective(aspect.perspective), value == aspectValue else {
                    return (false, [])
                }
                return (true, [aspect.perspective])
            case .unequal:
                guard information.takesPerspective(aspect.perspective), value != aspectValue else {
                    return (false, [])
                }
                return (true, [aspect.perspective])
            }
        }
    }
}
