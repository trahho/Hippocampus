//
//  Structure.Query.Presentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.03.23.
//

import Foundation

extension Structure.Query {
    enum Presentation: Structure.PersistentValue {
        case list, tree, map
    }
}
