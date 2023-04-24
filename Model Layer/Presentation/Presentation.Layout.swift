//
//  Presentation.Layout.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.04.23.
//

import Foundation
extension Presentation {
    enum Layout: Codable, Hashable {
        case list
        case tree
        case map
        case gallery
        case canvas
    }
}
