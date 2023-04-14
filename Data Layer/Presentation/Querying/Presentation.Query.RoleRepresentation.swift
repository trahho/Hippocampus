//
//  Presentation.Query.RoleRepresentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.04.23.
//

import Foundation

extension Presentation.Query {
    struct RoleRepresentation: Serializable, Equatable {
        
        static func == (lhs: Presentation.Query.RoleRepresentation, rhs: Presentation.Query.RoleRepresentation) -> Bool {
            lhs.roleId == rhs.roleId && lhs.representation == rhs.representation
        }
        
        @Serialized var roleId: Structure.Role.ID
        @Serialized var representation: String

        init() {}

        init(_ role: Structure.Role, _ representation: String) {
            self.roleId = role.id
            self.representation = representation
        }
    }
}
