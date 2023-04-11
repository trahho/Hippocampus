//
//  Structure.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import SwiftUI

extension Structure {
    class Aspect: Object {
        @Persistent var name: String = ""
        @Persistent var presentation: Presentation
        @Persistent var index = 0
//        @Persistent var defaultValue: (any PersistentValue)?

        @Relation(inverse: "aspects") var role: Role!
    }
}
