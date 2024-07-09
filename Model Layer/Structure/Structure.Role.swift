//
//  Role.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Grisu
import Smaug
import SwiftUI

extension Structure {
    @dynamicMemberLookup
    class Role: Object, EditableListItem {
        @Property var name = ""
        @Objects var roles: [Role]
        @Objects(deleteReferences: true) var aspects: [Aspect] 
        @Property var particles: [Particle] = []

        @Relations(\Role.roles) var subRoles: [Role]
        @Objects var references: [Role]
        @Relations(\Role.references) var referencedBy: [Role]
        @Property var representations: [Representation] = []

        subscript(dynamicMember dynamicMember: String) -> Aspect {
            if let result = aspects.first(where: { $0.name.lowercased() == dynamicMember.lowercased() }) {
                return result
            } else {
                return roles.compactMap { $0[dynamicMember: dynamicMember] }.first!
            }
        }

        var allRoles: [Role] {
            (roles.flatMap { $0.allRoles } + [self]).asSet.asArray
        }

        func conforms(to role: Role) -> Bool {
            role == self || !roles.filter { $0.conforms(to: role) }.isEmpty
        }

        var allReferences: [Role] {
            references.asSet.union(roles.flatMap { $0.allReferences }.map { self.conforms(to: $0) ? self : $0 }).asArray
        }

        var allReferencedBy: [Role] {
            referencedBy.asSet.union(roles.flatMap { $0.allReferencedBy }.map { self.conforms(to: $0) ? self : $0 }).asArray
        }

        var allAspects: [Aspect] {
            aspects.asSet.union(roles.flatMap { $0.allAspects }).asArray
        }

   
    }
}
