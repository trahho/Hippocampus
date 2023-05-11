//
//  Structure.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

//class Structure: DataStore<Document.Storage> {
class Structure: ObjectStore {
    @Objects var roles: Set<Role>
    @Objects var aspects: Set<Aspect>
    @Objects var representations: Set<Representation>
    @Objects var references: Set<Reference>

//    override func setup() {
//        let roles: [Role] = [.global, .drawing, .text, .topic, .note]
//        roles.forEach {
//            self.add($0)
//        }
//    }
}
