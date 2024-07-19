//
//  Structure.Role+static.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.06.24.
//

import Foundation
import Grisu
import SwiftUI

extension Structure.Role {
    typealias Role = Structure.Role
    typealias Aspect = Structure.Aspect
    typealias Particle = Structure.Particle

    static var statics: [Role] = [.same, .drawing, .hierarchical, .named, .note, .text, .topic, .tracked]

    static let same: Role = {
        var role = Role(id: "00000000-0000-0000-0000-000000000001".uuid)
        role.name = "same"
        return role
    }()

    static let drawing: Role = {
        var role = Role(id: "8ECEA3AE-1E0B-4DDD-BABE-5836C577FE08".uuid)
        role.name = "drawing"
        role.aspects = [
            {
                let aspect = Aspect(id: "F5DC22EC-A54E-428E-8C2A-99A543521AA5".uuid)
                aspect.name = "drawing"
                aspect.kind = .drawing
                aspect.computed = false
                return aspect
            }(),
        ]
        return role
    }()

    static let hierarchical: Role = {
        var role = Role(id: "B6D7755C-210C-484D-B79B-ACD931D581C9".uuid)
        role.name = "hierarchical"
        role.roles = [.named]
        role.references = [.same]
        role.representations = [
            {
                let representation = Representation(id: "AE043B77-C4F7-454C-A530-5D8BECFAFC80".uuid)
                representation.name = ""
                representation.layouts = []
                representation.presentation = .background([
                    .horizontal([
                        .color([
                            .aspect("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, appearance: .normal),
                            .label("Hallo"),
                        ], color: Color(hex: "8F0F8F")),
                        .label("Welt"),
                    ], alignment: .center),
                ], color: Color(hex: "F5F28F"))
                return representation
            }(),
            {
                let representation = Representation(id: "7D49DC1F-AC7E-45B6-97D4-BE37093018F3".uuid)
                representation.name = ""
                representation.layouts = [.tree, .list]
                representation.presentation = .horizontal([
                    .color([
                        .icon("bookmark.fill"),
                    ], color: Color(hex: "6080FF")),
                    .aspect("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, appearance: .normal),
                ], alignment: .center)
                return representation
            }(),
        ]
        return role
    }()
 
    static let named: Role = {
        var role = Role(id: "8A81358C-2A7C-497D-A93D-306F776C217C".uuid)
        role.name = "named"
        role.aspects = [
            {
                let aspect = Aspect(id: "6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid)
                aspect.name = "text"
                aspect.kind = .text
                aspect.computed = false
                return aspect
            }(),
        ]
        role.representations = [
            {
                let representation = Representation(id: "7B8DDE7F-F331-41C9-BD64-B097E2050A1D".uuid)
                representation.name = ""
                representation.layouts = [.list, .tree]
                representation.presentation = .horizontal([
                    .color([
                        .aspect("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, appearance: .icon),
                    ], color: Color(hex: "FF0019")),
                    .aspect("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, appearance: .normal),
                ], alignment: .center)
                return representation
            }(),
        ]
        return role
    }()

    static let note: Role = {
        var role = Role(id: "8AB172CF-2330-4861-B551-8728BA6062BF".uuid)
        role.name = "note"
        role.roles = [.named, .tracked, .text, .drawing]
        return role
    }()

    static let text: Role = {
        var role = Role(id: "73874A60-423C-4128-9A5A-708D4350FEF3".uuid)
        role.name = "text"
        role.aspects = [
            {
                let aspect = Aspect(id: "F0C2B7D0-E71A-4296-9190-8EF2D540338F".uuid)
                aspect.name = "text"
                aspect.kind = .text
                aspect.computed = false
                return aspect
            }(),
        ]
        return role
    }()

    static let topic: Role = {
        var role = Role(id: "3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0".uuid)
        role.name = "topic"
        role.roles = [.hierarchical, .named, .tracked]
        role.references = [.note]
        role.aspects = [
            {
                let aspect = Aspect(id: "B945443A-32D6-4FE7-A63F-65436CAAA3CA".uuid)
                aspect.name = "titel"
                aspect.kind = .text
                aspect.computed = false
                return aspect
            }(),
        ]
        return role
    }()

    static let tracked: Role = {
        var role = Role(id: "D7812874-085B-4161-9ABB-C82D4A145634".uuid)
        role.name = "tracked"
        role.aspects = [
            {
                let aspect = Aspect(id: "E851210E-7CCC-4D09-87C1-A7E75E04D7F4".uuid)
                aspect.name = "created"
                aspect.kind = .date
                aspect.computed = false
                return aspect
            }(),
        ]
        role.particles = [
            {
                let particle = Particle(id: "00000000-0000-0000-0000-000500000000".uuid)
                particle.name = "whatever"
                return particle
            }(),
        ]
        return role
    }()
}

// extension Structure.Role
// {
//    typealias Role = Structure.Role
//    typealias Aspect = Structure.Aspect
//    typealias Particle = Structure.Particle
//
//    static var statics: [Role] = [.same, .drawing, .hierarchical, .named, .note, .text, .topic, .tracked]
//
//    static let same: Role = {
//        var role = Role(id: "00000000-0000-0000-0000-000000000000".uuid)
//        role.name = "same"
//        return role
//    }()
//
//    static let drawing: Role = {
//        var role = Role(id: "8ECEA3AE-1E0B-4DDD-BABE-5836C577FE08".uuid)
//        role.name = "drawing"
//        role.aspects = [
//            {
//                let aspect = Aspect(id: "F5DC22EC-A54E-428E-8C2A-99A543521AA5".uuid)
//                aspect.name = "drawing"
//                aspect.kind = .drawing
//                return aspect
//            }()
//        ]
//        return role
//    }()
//
//    static let hierarchical: Role = {
//        var role = Role(id: "B6D7755C-210C-484D-B79B-ACD931D581C9".uuid)
//        role.name = "hierarchical"
//        role.roles = [.named]
//        role.references = [.same]
//        role.representations = [
//            {
//                let representation = Representation(id: "AE043B77-C4F7-454C-A530-5D8BECFAFC80".uuid)
//                representation.name = ""
//                representation.presentation = .background([
//                    .horizontal([
//                        .color([
//                            .aspect("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, appearance: .normal),
//                            .label("Hallo")
//                        ], color: Color(hex: "8F0F8F")),
//                        .label("Welt")
//                    ], alignment: .center)
//                ], color: Color(hex: "F5F28F"))
//                return representation
//            }()
//        ]
//        return role
//    }()
//
//    static let named: Role = {
//        var role = Role(id: "8A81358C-2A7C-497D-A93D-306F776C217C".uuid)
//        role.name = "named"
//        role.aspects = [
//            {
//                let aspect = Aspect(id: "6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid)
//                aspect.name = "name"
//                aspect.kind = .text
//                return aspect
//            }()
//        ]
//        return role
//    }()
//
//    static let note: Role = {
//        var role = Role(id: "8AB172CF-2330-4861-B551-8728BA6062BF".uuid)
//        role.name = "note"
//        role.roles = [.named, .tracked, .text, .drawing]
//        return role
//    }()
//
//    static let text: Role = {
//        var role = Role(id: "73874A60-423C-4128-9A5A-708D4350FEF3".uuid)
//        role.name = "text"
//        role.aspects = [
//            {
//                let aspect = Aspect(id: "F0C2B7D0-E71A-4296-9190-8EF2D540338F".uuid)
//                aspect.name = "text"
//                aspect.kind = .text
//                return aspect
//            }()
//        ]
//        return role
//    }()
//
//    static let topic: Role = {
//        var role = Role(id: "3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0".uuid)
//        role.name = "topic"
//        role.roles = [.hierarchical, .named, .tracked]
//        role.references = [.note]
//        role.aspects = [
//            {
//                let aspect = Aspect(id: "B945443A-32D6-4FE7-A63F-65436CAAA3CA".uuid)
//                aspect.name = "titel"
//                aspect.kind = .text
//                return aspect
//            }()
//        ]
//        return role
//    }()
//
//    static let tracked: Role = {
//        var role = Role(id: "D7812874-085B-4161-9ABB-C82D4A145634".uuid)
//        role.name = "tracked"
//        role.aspects = [
//            {
//                let aspect = Aspect(id: "E851210E-7CCC-4D09-87C1-A7E75E04D7F4".uuid)
//                aspect.name = "created"
//                aspect.kind = .date
//                return aspect
//            }()
//        ]
//        return role
//    }()
// }
