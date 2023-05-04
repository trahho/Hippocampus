//
//  Structure.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

class Structure: DataStore<Structure.Storage> {
    @Objects var roles: Set<Role>
    @Objects var aspects: Set<Aspect>

    func setup() -> Structure {
        let roles: [Role] = [.global, .drawing, .text, .topic, .note]
        roles.forEach {
            document.add($0)
        }

        return self
    }
}
