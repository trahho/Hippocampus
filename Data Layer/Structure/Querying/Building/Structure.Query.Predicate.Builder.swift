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

extension Structure.Query.RoleRepresentation {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.Query.RoleRepresentation] { [] }

        static func buildBlock(_ predicates: Structure.Query.RoleRepresentation...) -> [Structure.Query.RoleRepresentation] {
            predicates
        }
    }
}

extension Structure.Query {
    convenience init(_ id: String,
                     _ name: String,
                     @Structure.Query.Predicate.Builder predicates: () -> [Structure.Query.Predicate] = { [] },
                     @Structure.Query.RoleRepresentation.Builder representations: () -> [Structure.Query.RoleRepresentation] = { [] })
    {
        self.init()
        self.id = UUID(uuidString: id)!
        self.name = name
        let predicates = predicates()
        self.predicates = predicates
        let representations = representations()
        self.roleRepresentations = representations
    }
}
