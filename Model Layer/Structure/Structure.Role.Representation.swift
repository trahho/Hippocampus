//
//  Structure.Role.Representation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import Grisu
import Smaug

extension Structure.Role {
    class Representation: ObjectPersistence.Object, EditableListItem {
        @Property/*(logChanges: true)*/ var presentation: Presentation = .undefined
        @Property var name: String = ""
        @Property var layouts: [Presentation.Layout] = []
    }
}
