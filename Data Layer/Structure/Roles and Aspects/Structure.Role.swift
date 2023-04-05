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
        static let global = Role("D7812874-085B-4161-9ABB-C82D4A145634", "_Global") {
            Aspect("8A81358C-2A7C-497D-A93D-306F776C217C", "_Name", .text)
            Aspect("E851210E-7CCC-4D09-87C1-A7E75E04D7F4", "_Created", .date)
        } representations: {
            Representation("_Title", .aspect("E851210E-7CCC-4D09-87C1-A7E75E04D7F4", form: .normal, editable: false))
        }

//    representations: {
//            [("", .aspect(Role.global.name, editable: false))]
//        }

        static let drawing = Role("6247260E-624C-48A1-985C-CDEDDFA5D3AD", "_Drawing") {
            Aspect("B6D7755C-210C-484D-B79B-ACD931D581C9", "_Drawing", .drawing)
        }

        static let text = Role("73874A60-423C-4128-9A5A-708D4350FEF3", "_Text") {
            Aspect("F0C2B7D0-E71A-4296-9190-8EF2D540338F", "_Text", .text)
        }

//    representations: {
//            []
//        }

        static let topic = Role("3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0", "_Topic", [.global])

        static let note = Role("8AB172CF-2330-4861-B551-8728BA6062BF", "_Note", [.global, .drawing, .text]) {
            Aspect("B945443A-32D6-4FE7-A63F-65436CAAA3CA", "_Headline", .text)
//            Aspect("8C6872C7-9E9F-470F-9E23-3A7277B1A9ED", "Text", .text)
        }

        @Persistent var roleDescription: String = ""
        @Persistent var representations: [Representation]

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

        func representation(for name: String) -> Structure.Representation {
            representations.first { $0.name == name }?.representation ?? .vertical([.undefined, .label(name)], alignment: .center)
        }
    }
}
