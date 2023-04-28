//
//  Structure.Role.Reference.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation

extension Structure {
    class Reference: Object {
        @Relation var role: Structure.Role?
        @Relation var referenced: Structure.Role?
        @Relation var referenceRole: Structure.Role?

        public required init() {}
    }
}
