//
//  Presentation.Query.RoleRepresentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.04.23.
//

import Foundation

extension Presentation.Query {
    class RoleRepresentation: Presentation.Object {
        static func == (lhs: Presentation.Query.RoleRepresentation, rhs: Presentation.Query.RoleRepresentation) -> Bool {
            lhs.roleId == rhs.roleId && lhs.representation == rhs.representation
        }

        @Persistent private var roleId: Structure.Role.ID
        @Persistent var representation: String

        var role: Structure.Role {
            get {
                base.role(id: roleId)
            }
            set {
                roleId = newValue.id
            }
        }

        required init() {}

        init(_ role: Structure.Role, _ representation: String) {
            super.init()
            self.roleId = role.id
            self.representation = representation
        }
    }
}
