//
//  Structure.Query.RoleRepresentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.04.23.
//

import Foundation

extension Structure.Query {
    struct RoleRepresentation: Serializable {

        @Serialized var roleId: Structure.Role.ID
        @Serialized var representation: String
        @Serialized var layouts: Set<Presentation.Layout> = []

        func representation(for layout: Presentation.Layout) -> String? {
            if layouts.isEmpty { return representation }
            if layouts.contains(layout) { return representation }
            return nil
        }
        
        init() {}
        
        init(_ role: Structure.Role, _ representation: String, _ layouts: Set<Presentation.Layout> = []) {
            self.roleId = role.id
            self.representation = representation
            self.layouts = layouts
        }
    }
}
