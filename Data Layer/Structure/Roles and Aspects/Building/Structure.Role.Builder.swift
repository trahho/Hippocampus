//
//  Structure.Role.Builder.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation

extension Structure.RoleReference {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.RoleReference] { [] }

        static func buildBlock(_ references: Structure.RoleReference...) -> [Structure.RoleReference] {
            references
        }
    }

    convenience init(_ referenced: Structure.Role, _ referenceRole: Structure.Role? = nil) {
        self.init()
        self.referenced = referenced
        self.referenceRole = referenceRole
    }
}

extension Structure.Role {
    @resultBuilder
    enum Builder {
        static func buildBlock() -> [Structure.Role] { [] }

        static func buildBlock(_ roles: Structure.Role...) -> [Structure.Role] {
            roles
        }
    }

    convenience init(_ id: String,
                     _ name: String,
                     _ subRoles: [Structure.Role] = [],
                     addToMenu: Bool = false,
                     @Structure.Aspect.Builder aspects: () -> [Structure.Aspect] = { [] },
                     @Structure.Role.Representation.Builder representations: () -> [Representation] = { [] },
                     @Structure.RoleReference.Builder associated: () -> [Structure.RoleReference] = { [] })
    {
        self.init()
        self.id = UUID(uuidString: id)!
        roleDescription = name
        canBeCreated = addToMenu
        let aspects = aspects()
        for i in 0 ..< aspects.count {
            aspects[i].index = i
        }
        self.aspects = aspects.asSet
        self.representations = representations()
        self.subRoles = subRoles.asSet
        self.references = associated().asSet
        print("Built role \(name)")
    }

    struct Representation: Structure.PersistentValue {
        let name: String
        let representation: Structure.Representation

        init(_ name: String, _ representation: Structure.Representation) {
            self.name = name
            self.representation = representation
        }

        @resultBuilder
        enum Builder {
            static func buildBlock() -> [Structure.Role.Representation] { [] }

            static func buildBlock(_ representations: Structure.Role.Representation...) -> [Structure.Role.Representation] {
                representations
            }
        }
    }
}
