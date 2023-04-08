//
//  Role.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import SwiftUI



extension Structure {
    @dynamicMemberLookup
    class Role: Object {
        @Persistent var roleDescription: String = ""
        @PublishedSerialized var representations: [Representation]
        @Serialized var isStatic = false
        @PublishedSerialized var canBeCreated = false

        @Relations(reverse: "role") var aspects: Set<Aspect>
        @Relations(reverse: "subRoles") var superRoles: Set<Role>
        @Relations(reverse: "superRoles", direction: .referenced) var subRoles: Set<Role>

        var allAspects: Set<Aspect> {
            subRoles.flatMap { $0.allAspects }.asSet.union(aspects)
        }

        var allRoles: Set<Role> {
            subRoles.flatMap { $0.allRoles }.asSet.union([self])
        }

        var isFinal: Bool {
            subRoles.isEmpty
        }

        subscript(dynamicMember dynamicMember: String) -> Aspect {
//            let first: (Aspect) -> Bool = { $0.name.lowercased().dropFirst() == dynamicMember.lowercased() }
            return allAspects.first { $0.name.lowercased().dropFirst() == dynamicMember.lowercased() }!
        }

        fileprivate func findRepresentation(for name: String) -> Structure.Representation? {
            if let first = representations.first(where: { $0.name == name })?.representation { return first }
            if name == "_Edit" {
                let aspectPresentations = allAspects
                    .sorted { ($0.index, $0.name) < ($1.index, $1.name) }
                    .map { Structure.Representation.aspect($0, form: .edit, editable: true) }
                return Structure.Representation.vertical(aspectPresentations, alignment: .leading)
            }
            if let first = subRoles.compactMap({ $0.findRepresentation(for: name) }).first { return first }
            if let first = Role.global.findRepresentation(for: name) { return first }
            return nil
        }

        func representation(for name: String) -> Structure.Representation {
            findRepresentation(for: name) ?? .vertical([.undefined, .label(name)], alignment: .center)
        }

        override func mergeValues(other: Object) {
            guard let other = other as? Role else { return }
            self.isStatic = other.isStatic
            self.representations = other.representations
            self.canBeCreated = other.canBeCreated
        }
    }
}
