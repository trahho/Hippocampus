//
//  Role.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
extension Structure {
    @dynamicMemberLookup
    class Role: Object {
        static let global = Role("D7812874-085B-4161-9ABB-C82D4A145634", "Global") {
            Aspect("8A81358C-2A7C-497D-A93D-306F776C217C", "Name", .text)
        }
        
        static let drawing = Role("6247260E-624C-48A1-985C-CDEDDFA5D3AD", "Zeichnung") {
            Aspect("B6D7755C-210C-484D-B79B-ACD931D581C9", "Zeichnung", .drawing)
        }
        
        static let topic = Role("3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0", "Thema", [Role.global]) {}
        
        static let note = Role("8AB172CF-2330-4861-B551-8728BA6062BF", "Notiz", [Role.global, Role.drawing]) {
            Aspect("B945443A-32D6-4FE7-A63F-65436CAAA3CA", "Titel", .text)
            Aspect("8C6872C7-9E9F-470F-9E23-3A7277B1A9ED", "Text", .text)
        }
        
        @Persistent var roleDescription: String = ""
        
        @Relations(inverse: "role") var aspects: Set<Aspect>
        @Relations(inverse: "subRoles") var superRoles: Set<Role>
        @Relations(inverse: "superRoles") var subRoles: Set<Role>
        
        subscript(dynamicMember dynamicMember: String) -> Aspect {
            let first :  (Aspect) -> Bool = { $0.name.lowercased() == dynamicMember.lowercased() }
            return aspects.first(where: first) ?? superRoles.flatMap { $0.aspects }.first(where: first)!
        }
    }
}
