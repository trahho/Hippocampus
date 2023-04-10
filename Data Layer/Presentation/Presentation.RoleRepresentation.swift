//
//  Structure.Query.RoleRepresentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.04.23.
//

import Foundation

extension Presentation {
    struct RoleRepresentation: Serializable {

        @Serialized var roleId: Structure.Role.ID
        @Serialized var representation: String

     
        init() {}
        
        init(_ role: Structure.Role, _ representation: String) {
            self.roleId = role.id
            self.representation = representation
        }
    }
}
