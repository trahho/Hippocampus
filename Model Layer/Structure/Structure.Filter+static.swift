//
//  Structure.Filter.static.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.06.24.
//

import Foundation
import Grisu
import SwiftUI

extension Structure.Filter {
    typealias Role = Structure.Role
    typealias Aspect = Structure.Aspect
    typealias Particle = Structure.Particle
    typealias Filter = Structure.Filter

    static var statics: [Filter] = [.test, .Filter_1]

    static let Filter_1: Filter = {
        var filter = Filter(id: "7BE4B482-DED6-48AD-BCD8-EC09EAF20432".uuid)
        filter.name = "Test 1"
        filter.layouts = [.tree,.list]
        filter.condition = .role("D7812874-085B-4161-9ABB-C82D4A145634".uuid)
        return filter
    }()
    
    static let test: Filter = {
        var filter = Filter()
        filter.name = "Test"
        filter.condition = .role("D7812874-085B-4161-9ABB-C82D4A145634".uuid)
        filter.layouts = [.list, .tree]
        filter.roles = [Structure.Role.note,Structure.Role.topic]
        filter.layout = .tree
        filter.orders = [.sorted("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, ascending: true)]
        filter.order = filter.orders.first!
        filter.representations = [
            {
                let representation = Representation(id: "501D0BB3-027F-4888-AD23-279933878E99".uuid)
                representation.condition = .role("B6D7755C-210C-484D-B79B-ACD931D581C9".uuid)
                representation.presentation = .vertical([
                    .horizontal([
                        .color([
                            .icon("star.fill"),
                        ], color: Color(hex: "FFD479")),
                    ], alignment: .center),
                    .role("B6D7755C-210C-484D-B79B-ACD931D581C9".uuid, layout: .list, name: nil),
                ], alignment: .leading)
                return representation
            }(),
        ]
        return filter
    }()
}
