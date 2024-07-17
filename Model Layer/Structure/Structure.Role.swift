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
    class Role: Object, EditableListItem, Pickable {
        // MARK: Properties

        @Property var name = ""
        @Objects var roles: [Role]
        @Objects(deleteReferences: true) var aspects: [Aspect]
        @Objects(deleteReferences: true) var particles: [Particle]

        @Relations(\Role.roles) var subRoles: [Role]
        @Objects var references: [Role]
        @Relations(\Role.references) var referencedBy: [Role]
        @Property var representations: [Representation] = []

        // MARK: Computed Properties

        var description: String {
            name.localized(isStatic)
        }

        var allRoles: [Role] {
            (roles.flatMap { $0.allRoles } + [self]).asSet.asArray
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

        // MARK: Functions

        subscript(dynamicMember dynamicMember: String) -> Aspect {
            if let result = aspects.first(where: { $0.name.lowercased() == dynamicMember.lowercased() }) {
                return result
            } else {
                return roles.compactMap { $0[dynamicMember: dynamicMember] }.first!
            }
        }

        subscript(dynamicMember dynamicMember: String) -> Particle {
            if let result = particles.first(where: { $0.name.lowercased() == dynamicMember.lowercased() }) {
                return result
            } else {
                return roles.compactMap { $0[dynamicMember: dynamicMember] }.first!
            }
        }

        func presentation(layout: Presentation.Layout, name: String? = nil) -> Presentation {
            allRoles
                .finalsFirst
                .flatMap {
                    $0.representations.filter {
                        $0.layouts.contains(layout) && $0.name == name ?? $0.name
                    }
                }
                .first?.presentation ?? .empty
        }

//            if let representation = representations.first(where: { $0.layouts.contains(layout) && $0.name == name ?? $0.name }) {
//                return representation.presentation
//            } else {
//                return allRoles.filter { $0.conforms(to: role) }
//                    .finalsFirst
//                    .compactMap { $0.presentation(for: role, layout: layout, name: name)}
//                    .first!
//            }
//
//        }

        func conforms(to role: Role) -> Bool {
            role == self || !roles.filter { $0.conforms(to: role) }.isEmpty
        }
    }
}
