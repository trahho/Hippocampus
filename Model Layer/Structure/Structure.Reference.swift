//
//  Structure.Role.Reference.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.04.23.
//

import Foundation

extension Structure {
    class Reference: Object {
        @Object var from: Structure.Role!
        @Object var to: Structure.Role!
        @Object var role: Structure.Role?

        public required init() {}
    }
}
