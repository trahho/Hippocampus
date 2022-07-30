//
//  NSPredicate+operators.swift
//  Hippocampus
//
//  Created by Guido Kühn on 07.07.22.
//

import Foundation
import CoreData

extension NSPredicate {
    static func && (lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [lhs, rhs])
    }

    static func || (lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(orPredicateWithSubpredicates: [lhs, rhs])
    }

    static prefix func ! (rhs: NSPredicate) -> NSPredicate {
        NSCompoundPredicate(notPredicateWithSubpredicate: rhs)
    }
}

