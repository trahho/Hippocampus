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

extension Presentation.RoleRepresentation {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Presentation.RoleRepresentation] { [] }

        static func buildBlock(_ predicates: Presentation.RoleRepresentation...) -> [Presentation.RoleRepresentation] {
            predicates
        }
    }
}

extension Structure.Query {
    convenience init(_ id: String,
                     _ name: String,
                     @Structure.Query.Predicate.Builder predicates: () -> [Structure.Query.Predicate] = { [] },
                     @Presentation.RoleRepresentation.Builder representations: () -> [Presentation.RoleRepresentation] = { [] })
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
