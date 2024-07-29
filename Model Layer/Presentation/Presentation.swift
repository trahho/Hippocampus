//
//  Arrangement.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.01.23.
//

import Foundation
import Grisu
import SwiftUI

indirect enum Presentation: Structure.PersistentValue, Hashable, Transferable {
    case empty
    case undefined
    case label(String)
    case icon(String)
    case aspect(Structure.Aspect.ID, appearance: Appearance)
    case horizontal([Presentation], alignment: Alignment)
    case vertical([Presentation], alignment: Alignment)
    case spaced([Presentation], horizontal: Space, vertical: Space)
    case color([Presentation], color: Color)
    case background([Presentation], color: Color)
    case grouped([Presentation])
    case role(Structure.Role.ID, layout: Layout, name: String? = nil)
//    case tap([Presentation])

    // MARK: Static Computed Properties

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Presentation.self, contentType: .text)
    }

    // MARK: Static Functions

    static func color(_ presentation: Presentation, color: Color) -> Presentation {
        .color([presentation], color: color)
    }

    static func background(_ presentation: Presentation, color: Color) -> Presentation {
        .background([presentation], color: color)
    }

    static func ascpect(_ aspect: Structure.Aspect, appearance: Appearance) -> Presentation {
        .aspect(aspect.id, appearance: appearance)
    }

    // MARK: Functions
}
