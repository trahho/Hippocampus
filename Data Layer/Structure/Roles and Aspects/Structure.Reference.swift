//
//  Structure.Role.Reference.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation

extension Structure {
    class Reference: Object {
        @Relation(reverse: "references", direction: .reference) var role: Structure.Role?
        @Relation(reverse: "referenced", direction: .reference) var referenced: Structure.Role?
        @Relation(direction: .reference) var referenceRole: Structure.Role?
        
        
        public required init() {
        }
    }
}
