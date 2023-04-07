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
        fileprivate enum Keys {
            static let global = "D7812874-085B-4161-9ABB-C82D4A145634"
            static let globalName = "8A81358C-2A7C-497D-A93D-306F776C217C"
            static let globalCreated = "E851210E-7CCC-4D09-87C1-A7E75E04D7F4"
            static let drawing = "6247260E-624C-48A1-985C-CDEDDFA5D3AD"
            static let drawingDrawing = "B6D7755C-210C-484D-B79B-ACD931D581C9"
            static let text = "73874A60-423C-4128-9A5A-708D4350FEF3"
            static let textText = "F0C2B7D0-E71A-4296-9190-8EF2D540338F"
        }

        static let global = Role(Keys.global, "_Global") {
            Aspect(Keys.globalName, "/Name", .text)
            Aspect(Keys.globalCreated, "/Created", .date)
        } representations: {
            Representation("_Title", .aspect(Keys.globalName, form: .normal))
        }

//    representations: {
//            [("", .aspect(Role.global.name, editable: false))]
//        }

        static let drawing = Role(Keys.drawing, "_Drawing", addToMenu: true) {
            Aspect(Keys.drawingDrawing, "/Drawing", .drawing)
        } representations: {
            Representation("_Icon", .aspect(Keys.drawingDrawing, form: .icon))
            Representation("_Card", .aspect(Keys.drawingDrawing, form: .small))
            Representation("_Canvas", .aspect(Keys.drawingDrawing, form: .normal))
        }

        static let text = Role(Keys.text, "_Text") {
            Aspect(Keys.textText, "/Text", .text)
        } representations: {
            Representation("_Introduction_Short", .aspect(Keys.textText, form: .firstParagraph))
        }

//    representations: {
//            []
//        }

        static let topic = Role("3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0", "_Topic", [.global], addToMenu: true)

        static let note = Role("8AB172CF-2330-4861-B551-8728BA6062BF", "_Note", [.global, .drawing, .text], addToMenu: true) {
            Aspect("B945443A-32D6-4FE7-A63F-65436CAAA3CA", "/Headline", .text)
//            Aspect("8C6872C7-9E9F-470F-9E23-3A7277B1A9ED", "Text", .text)
        }

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
//            if let first = subRoles.compactMap({ $0.findRepresentation(for: name) }).first { return first }
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
