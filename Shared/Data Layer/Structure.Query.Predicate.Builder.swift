//
//  Structure.Query.Predicate.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
extension Structure.Query.Predicate {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.Query.Predicate] { [] }

        static func buildBlock(_ predicates: Structure.Query.Predicate...) -> [Structure.Query.Predicate] {
            predicates
        }
    }

    init(_ roles: [Structure.Role], _ condition: Information.Condition) {
        self.condition = condition
        self.roles = roles.asSet
    }
}

extension Structure.Query {
    convenience init(_ id: String, _ name: String, @Structure.Query.Predicate.Builder predicates: () -> [Structure.Query.Predicate]) {
        self.init()
        self.id = UUID(uuidString: id)!
        self.name = name
        let predicates = predicates()
        self.predicates = predicates
    }
}
