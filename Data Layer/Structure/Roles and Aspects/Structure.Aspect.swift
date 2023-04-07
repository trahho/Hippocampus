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
        @Serialized var index = 0
//        @Persistent var defaultValue: (any PersistentValue)?

        @Relation(inverse: "aspects") var role: Role!
        
        override func mergeValues(other: PersistentData.Object) {
            guard let other = other as? Aspect else { return }
            index = other.index
        }
    }
}
