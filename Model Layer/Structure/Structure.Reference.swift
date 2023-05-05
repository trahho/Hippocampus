//
//  Structure.Role.Reference.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation

extension Structure {
    class Reference: Object {
        @Object var role: Structure.Role!
        @Object var referenced: Structure.Role!
        @Object var referenceRole: Structure.Role?

        public required init() {}
    }
}
