//
//  Role.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import SwiftUI
import Smaug

extension Structure {
    @dynamicMemberLookup
    class Role: Object {
        @Serialized var isStatic = false
        @PublishedSerialized var canBeCreated = false

        @Property var roleDescription: String = ""
        @Objects var representations: Set<Representation>
        @Objects var aspects: Set<Aspect>
        @Objects var superRoles: Set<Role>
        @Objects var subRoles: Set<Role>
        @Objects var references: Set<Reference>

        var allAspects: Set<Aspect> {
            subRoles.flatMap(\.allAspects).asSet.union(aspects)
        }

        var allRoles: Set<Role> {
            subRoles.flatMap(\.allRoles).asSet.union([self])
        }

        var isFinal: Bool {
            subRoles.isEmpty
        }

        subscript(dynamicMember dynamicMember: String) -> Aspect {
//            let first: (Aspect) -> Bool = { $0.name.lowercased().dropFirst() == dynamicMember.lowercased() }
            allAspects.first { $0.name.lowercased().dropFirst() == dynamicMember.lowercased() }!
        }

        fileprivate func findRepresentation(for name: String) -> Structure.Presentation? {
            if let first = representations.first(where: { $0.name == name })?.presentation { return first }
            if name == "_Edit" {
                let aspectPresentations = allAspects
                    .sorted { ($0.index, $0.name) < ($1.index, $1.name) }
                    .map { Structure.Presentation.aspect($0, form: Structure.Aspect.Presentation.Form.edit, editable: true) }
                return Structure.Presentation.vertical(aspectPresentations, alignment: .leading)
            }
            if let first = subRoles.compactMap({ $0.findRepresentation(for: name) }).first { return first }
            if let first = Role.global.findRepresentation(for: name) { return first }
            return nil
        }

        func representation(for name: String) -> Structure.Presentation {
            findRepresentation(for: name) ?? .vertical([.undefined, .label(name)], alignment: .center)
        }

        override func mergeValues(other: Object) {
            guard let other = other as? Role else { return }
            self.isStatic = other.isStatic
            self.canBeCreated = other.canBeCreated
        }
    }
}
