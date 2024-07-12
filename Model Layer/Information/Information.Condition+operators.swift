//
//  Information.Condition+operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation

infix operator ~>: AdditionPrecedence
infix operator <~: AdditionPrecedence

prefix operator ~>
postfix operator <~

// prefix operator ~> :  PrecedenceGroup
extension Information.Condition {
    static prefix func ! (rhs: Information.Condition) -> Information.Condition {
        .not(rhs)
    }

    static func ~> (lhs: Information.Condition, rhs: Information.Condition) -> Information.Condition {
        lhs && .hasReference(rhs)
    }

    static prefix func ~> (rhs: Information.Condition) -> Information.Condition {
        .hasReference(rhs)
    }

    static func <~ (lhs: Information.Condition, rhs: Information.Condition) -> Information.Condition {
        rhs && .isReferenced(lhs)
    }

    static postfix func <~ (lhs: Information.Condition) -> Information.Condition {
        .isReferenced(lhs)
    }

//    static postfix func <~ (lhs: Structure.Role) -> Information.Condition {
//        .isReferenced(.role(lhs.id))
//    }

    static func && (lhs: Information.Condition, rhs: Information.Condition) -> Information.Condition {
        guard lhs != .nil else { return rhs }
        guard rhs != .nil else { return lhs }

        if case let .all(lhsConditions) = lhs, case let .all(rhsConditions) = rhs {
            return .all(lhsConditions + rhsConditions)
        } else if case let .all(lhsConditions) = lhs {
            return .all(lhsConditions + [rhs])
        } else if case let .all(rhsConditions) = rhs {
            return .all([lhs] + rhsConditions)
        } else {
            return .all([lhs, rhs])
        }
    }

    static func || (lhs: Information.Condition, rhs: Information.Condition) -> Information.Condition {
        guard lhs != .nil else { return rhs }
        guard rhs != .nil else { return lhs }

        if case let .any(lhsConditions) = lhs, case let .any(rhsConditions) = rhs {
            return .any(lhsConditions + rhsConditions)
        } else if case let .any(lhsConditions) = lhs {
            return .any(lhsConditions + [rhs])
        } else if case let .any(rhsConditions) = rhs {
            return .any([lhs] + rhsConditions)
        } else {
            return .any([lhs, rhs])
        }
    }
}
