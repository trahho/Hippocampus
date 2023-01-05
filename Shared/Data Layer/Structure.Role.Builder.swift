//
//  Structure.Role.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation

extension Structure.Role {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.Role] { [] }

        static func buildBlock(_ roles: Structure.Role...) -> [Structure.Role] {
            roles
        }
    }

    convenience init(_ id: String, _ name: String, _ superRoles: [Structure.Role] = [], @Structure.Aspect.Builder aspects: () -> [Structure.Aspect]) {
        self.init()
        self.id = UUID(uuidString: id)!
        self.roleDescription = name
        self.aspects = aspects().asSet
        self.superRoles = superRoles.asSet
    }
}
