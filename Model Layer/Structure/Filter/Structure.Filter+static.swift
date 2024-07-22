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

    static var statics: [Filter] = [.test]

    static let test: Filter = {
        var filter = Filter()
        filter.name = "Test"
        filter.condition = .role("D7812874-085B-4161-9ABB-C82D4A145634".uuid)
        filter.layouts = [.list, .tree]
        filter.roles = [Structure.Role.note, Structure.Role.topic]
        filter.layout = .tree
        filter.orders = [.sorted("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, ascending: false)]
        filter.order = filter.orders.first!
        filter.representations = [
            {
                let representation = Representation()
                representation.condition = .role(Structure.Role.named.id)
                representation.presentation = .vertical([
                    .horizontal([
                        .color([
                            .icon("star.fill"),
                        ], color: Color(hex: "F71DC9")),
                    ], alignment: .center),
                    .role(Structure.Role.named.id, layout: .list, name: nil),
                ], alignment: .leading)
                return representation
            }(),
        ]
        return filter
    }()
}
