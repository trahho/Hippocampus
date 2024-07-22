//
//  Structure.Filter.Representation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.07.24.
//

import Foundation
import Grisu
import Smaug

extension Structure.Filter {
    class Representation: ObjectPersistence.Object, EditableListItem {
        @Property var condition: Information.Condition = .nil
        @Property var presentation: Presentation = .undefined
    }
}
