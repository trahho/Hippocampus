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

    override func setup() {
        let roles: [Role] = [.global, .drawing, .text, .topic, .note]
        roles.forEach {
            document.add($0)
        }
    }
}
