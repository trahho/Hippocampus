//
//  Role.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Smaug
import SwiftUI

extension Structure {
    @dynamicMemberLookup
    class Role: Object {
        @Property var name = ""
        @Objects var roles: Set<Role>
        @Relations(\Role.roles) var compatible: Set<Role>
        @Objects var aspects: Set<Aspect>
        @Objects var references: Set<Role>
        @Relations(\Role.references) var referencedBy: Set<Role>

        subscript(dynamicMember dynamicMember: String) -> Aspect {
            if let result = aspects.first(where: { $0.name.lowercased().dropFirst() == dynamicMember.lowercased() }) {
                return result
            } else {
                return roles.compactMap { $0[dynamicMember: dynamicMember] }.first!
            }
        }

        func conforms(to role: Role) -> Bool {
            role == self || !roles.filter { $0.conforms(to: role) }.isEmpty
        }

        var to: Set<Role> {
            references.union(roles.flatMap { $0.to }.map { self.conforms(to: $0) ? self : $0 })
        }

        var from: Set<Role> {
            referencedBy.union(roles.flatMap { $0.from }.map { self.conforms(to: $0) ? self : $0 })
        }

        var allAspects: Set<Aspect> {
            aspects.union(roles.flatMap { $0.allAspects })
        }

        //        @Property var roleDescription: String = ""
        //        @Objects var representations: Set<Representation>
        //        @Objects var aspects: Set<Aspect>
        //        @Objects var subRoles: Set<Role>
        ////        @Relations(\Role.subRoles) var superRoles: Set<Role>
        //        @Objects var references: Set<Reference>
        //
        //        var allAspects: Set<Aspect> {
        //            subRoles.flatMap(\.allAspects).asSet.union(aspects)
        //        }
        //
        //        var allRoles: Set<Role> {
        //            subRoles.flatMap(\.allRoles).asSet.union([self])
        //        }
        //
        //        var isFinal: Bool {
        //            subRoles.isEmpty
        //        }
        //
        //        subscript(dynamicMember dynamicMember: String) -> Aspect {
        ////            let first: (Aspect) -> Bool = { $0.name.lowercased().dropFirst() == dynamicMember.lowercased() }
        //            allAspects.first { $0.name.lowercased().dropFirst() == dynamicMember.lowercased() }!
        //        }
        //
        //        fileprivate func findRepresentation(for name: String) -> Structure.Presentation? {
        //            if let first = representations.first(where: { $0.name == name })?.presentation { return first }
        //            if name == "_Edit" {
        //                let aspectPresentations = allAspects
        //                    .sorted { ($0.index, $0.name) < ($1.index, $1.name) }
        //                    .map { Structure.Presentation.aspect($0, form: Structure.Aspect.Presentation.Form.edit, editable: true) }
        //                return Structure.Presentation.vertical(aspectPresentations, alignment: .leading)
        //            }
        //            if let first = subRoles.compactMap({ $0.findRepresentation(for: name) }).first { return first }
        //            if let first = Role.global.findRepresentation(for: name) { return first }
        //            return nil
        //        }
        //
        //        func representation(for name: String) -> Structure.Presentation {
        //            findRepresentation(for: name) ?? .vertical([.undefined, .label(name)], alignment: .center)
        //        }
        //
        ////        override func merge(other: Mergeable) throws {
        ////            try super.merge(other: other)
        ////            guard let other = other as? Role else { throw MergeError.wrongMatch  }
        ////            self.canBeCreated = other.canBeCreated
        ////        }
        //    }
    }
}
