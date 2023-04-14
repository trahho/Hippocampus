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

        @Serialized var roleId: Structure.Role.ID
        @Serialized var representation: String

        var role: Structure.Role? {
            get {
                guard let database = graph as? Presentation, let role: Structure.Role = database.structure?[id] else { return nil }
                return role
            }
            set {
                guard let newValue else { return }
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
