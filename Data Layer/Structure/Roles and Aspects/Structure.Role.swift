//
//  Role.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import SwiftUI

extension Structure {
    class RoleReference: Object {
        @Relation(reverse: "references", direction: .reference) var role: Structure.Role?
        @Relation(reverse: "referenced", direction: .reference) var referenced: Structure.Role?
        @Relation(direction: .reference) var referenceRole: Structure.Role?
        
        
        public required init() {
        }
    }

    @dynamicMemberLookup
    class Role: Object {
        @Serialized var isStatic = false
        @PublishedSerialized var canBeCreated = false

        @Persistent var roleDescription: String = ""
        @Persistent var representations: [Representation]
        @Relations(reverse: "role", direction: .referenced) var aspects: Set<Aspect>
        @Relations(reverse: "subRoles") var superRoles: Set<Role>
        @Relations(reverse: "superRoles", direction: .referenced) var subRoles: Set<Role>
        @Relations(reverse: "role", direction: .referenced) var references: Set<RoleReference>

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

        fileprivate func findRepresentation(for name: String) -> Structure.Representation? {
//            if let first = representations.first(where: { $0.name == name })?.representation { return first }
//            if name == "_Edit" {
//                let aspectPresentations = allAspects
//                    .sorted { ($0.index, $0.name) < ($1.index, $1.name) }
//                    .map { Structure.Representation.aspect($0, form: .edit, editable: true) }
//                return Structure.Representation.vertical(aspectPresentations, alignment: .leading)
//            }
//            if let first = subRoles.compactMap({ $0.findRepresentation(for: name) }).first { return first }
//            if let first = Role.global.findRepresentation(for: name) { return first }
            return nil
        }

        func representation(for name: String) -> Structure.Representation {
            findRepresentation(for: name) ?? .vertical([.undefined, .label(name)], alignment: .center)
        }

        override func mergeValues(other: Object) {
            guard let other = other as? Role else { return }
            self.isStatic = other.isStatic
            self.canBeCreated = other.canBeCreated
        }
    }
}
