//
//  Mind.Opinion+Operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.09.22.
//

import Foundation

infix operator ~>: AdditionPrecedence
infix operator <~: AdditionPrecedence

extension Mind.Opinion {
    static prefix func ! (rhs: Mind.Opinion) -> Mind.Opinion {
        .wrong(rhs)
    }

    static func && (lhs: Mind.Opinion, rhs: Mind.Opinion) -> Mind.Opinion {
        if let lhs = lhs as? AboutMany.All, let rhs = rhs as? AboutMany.All {
            return AboutMany.All(lhs.opinions + rhs.opinions)
        } else if let lhs = lhs as? AboutMany.All {
            return AboutMany.All(lhs.opinions + [rhs])
        } else if let rhs = rhs as? AboutMany.All {
            return AboutMany.All([lhs] + rhs.opinions)
        } else {
            return AboutMany.All([lhs, rhs])
        }
    }

    static func || (lhs: Mind.Opinion, rhs: Mind.Opinion) -> Mind.Opinion {
        typealias Or = AboutMany.Some
        if let lhs = lhs as? Or, let rhs = rhs as? Or {
            return Or(lhs.opinions + rhs.opinions)
        } else if let lhs = lhs as? Or {
            return Or(lhs.opinions + [rhs])
        } else if let rhs = rhs as? Or {
            return Or([lhs] + rhs.opinions)
        } else {
            return Or([lhs, rhs])
        }
    }

    static func ~> (lhs: Mind.Opinion, rhs: Mind.Opinion) -> Mind.Opinion {
        lhs && AboutOne.Acquaintance(.knows, rhs)
    }

    static func <~ (_: Mind.Opinion, rhs: Mind.Opinion) -> Mind.Opinion {
        AboutOne.Acquaintance(.known, rhs) && rhs
    }
}
