//
//  Structure.Query.Predicate.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
extension Presentation.Query.Predicate {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Presentation.Query.Predicate] { [] }

        static func buildBlock(_ predicates: Presentation.Query.Predicate...) -> [Presentation.Query.Predicate] {
            predicates
        }
    }

    init(_ roles: [Structure.Role], _ condition: Information.Condition) {
        self.condition = condition
        self.roles = roles.map { $0.id }.asSet
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
                     @Presentation.Query.Predicate.Builder predicates: () -> [Presentation.Query.Predicate] = { [] },
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
