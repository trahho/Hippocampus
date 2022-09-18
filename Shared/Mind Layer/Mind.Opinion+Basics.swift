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

        override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective.ID>) {
            return (right, [])
        }
    }

    class TakesPerspective: Mind.Opinion {
        @Serialized var perspective: Perspective.ID

        required init() {}

        init(perspective: Perspective.ID) {
            super.init()
            self.perspective = perspective
        }

        override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective.ID>) {
            information.takesPerspective(perspective) ? (true, [perspective]) : (false, [])
        }
    }

    class AspectValueComparison<T: ComparableCodable>: Mind.Opinion {
        enum Comparison {
            case below, above, equal, unequal
        }

        @Serialized var aspect: Aspect.ID
        @Serialized var perspective: Perspective.ID
        @Serialized var value: T?
        @Serialized var comparison: Comparison

        required init() {}

        init(perspective: Perspective.ID, aspect: Aspect.ID, comparison: Comparison, value: T?) {
            super.init()
            self.perspective = perspective
            self.aspect = aspect
            self.comparison = comparison
            self.value = value
        }

        override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective.ID>) {
            let aspectValue = information[aspect] as? T
            switch comparison {
            case .below:
                guard information.takesPerspective(perspective), value != nil, aspectValue == nil || aspectValue! < value! else {
                    return (false, [])
                }
                return (true, [perspective])
            case .above:
                guard information.takesPerspective(perspective), aspectValue != nil, value == nil || aspectValue! > value! else {
                    return (false, [])
                }
                return (true, [perspective])
            case .equal:
                guard information.takesPerspective(perspective), value == aspectValue else {
                    return (false, [])
                }
                return (true, [perspective])
            case .unequal:
                guard information.takesPerspective(perspective), value != aspectValue else {
                    return (false, [])
                }
                return (true, [perspective])
            }
        }
    }
}
