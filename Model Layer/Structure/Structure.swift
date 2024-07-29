//
//  Structure.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

class Structure: ObjectStore {
    @Objects var roles: Set<Role>
    @Objects var particles: Set<Particle>
    @Objects var aspects: Set<Aspect>
    @Objects var filters: Set<Filter>
    @Property var migration: Int = 0

    //    override func setup() {
//        let roles: [Role] = [.global, .drawing, .text, .topic, .note]
//        roles.forEach {
//            self.add($0)
//        }
//    }
}
