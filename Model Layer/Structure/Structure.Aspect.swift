//
//  Structure.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import SwiftUI
import Smaug

extension Structure {
    class Aspect: Object {
        @Property var name: String = ""
        @Property var presentation: Presentation
        @Property var index = 0
//        @Persistent var defaultValue: (any PersistentValue)?

        @Reference(\Role.aspects) var role: Role!
    }
}
