//
//  Structure.Query.Predicate.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
extension Presentation.Predicate {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Presentation.Predicate] { [] }

        static func buildBlock(_ predicates: Presentation.Predicate...) -> [Presentation.Predicate] {
            predicates
        }
    }

    convenience init(_ roles: [Structure.Role], _ condition: Information.Condition) {
        self.init()
        self.condition = condition
        self.roles = roles.asSet
    }
}

extension Presentation.Query.RoleRepresentation {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Presentation.Query.RoleRepresentation] { [] }

        static func buildBlock(_ predicates: Presentation.Query.RoleRepresentation...) -> [Presentation.Query.RoleRepresentation] {
            predicates
        }
    }
}

extension Presentation.Query {
    convenience init(_ id: String,
                     _ name: String,
                     @Presentation.Predicate.Builder predicates: () -> [Presentation.Predicate] = { [] },
                     @Presentation.Query.RoleRepresentation.Builder representations: () -> [Presentation.Query.RoleRepresentation] = { [] })
    {
        self.init()
        self.id = UUID(uuidString: id)!
        self.name = name
        let predicates = predicates()
        self.predicates = predicates
        let representations = representations()
        roleRepresentations = representations
    }
}
