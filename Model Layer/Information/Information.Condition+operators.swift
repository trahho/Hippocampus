//
//  Information.Condition+operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation

infix operator ~>: AdditionPrecedence
infix operator <~: AdditionPrecedence


extension Information.Condition {
    static prefix func ! (rhs: PersistentGraph.Condition) -> PersistentGraph.Condition {
        .not(rhs)
    }
    
    static func ~> (lhs: PersistentGraph.Condition, rhs: PersistentGraph.Condition) -> PersistentGraph.Condition {
        lhs && .hasReference(rhs)
    }
    
    static func <~ (lhs: PersistentGraph.Condition, rhs: PersistentGraph.Condition) -> PersistentGraph.Condition {
        rhs && .isReferenced(lhs)
    }

    static func && (lhs: PersistentGraph.Condition, rhs: PersistentGraph.Condition) -> PersistentGraph.Condition {
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

    static func || (lhs: PersistentGraph.Condition, rhs: PersistentGraph.Condition) -> PersistentGraph.Condition {
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
