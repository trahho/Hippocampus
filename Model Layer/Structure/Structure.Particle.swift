//
//  Structure.Particle.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.06.24.
//

import Foundation
import Grisu
import Smaug

extension Structure {
    @dynamicMemberLookup
    class Particle: Object, EditableListItem {
        @Property var name = ""
        @Property var aspects: [Aspect] = []

        subscript(dynamicMember dynamicMember: String) -> Aspect {
            aspects.first(where: { $0.name.lowercased() == dynamicMember.lowercased() })!
        }
    }
}
