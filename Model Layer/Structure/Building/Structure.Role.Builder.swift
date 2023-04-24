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

    convenience init(_ id: String,
                     _ name: String,
                     _ subRoles: [Structure.Role] = [],
                     addToMenu: Bool = false,
                     @Structure.Aspect.Builder aspects: () -> [Structure.Aspect] = { [] },
                     @Structure.Representation.Builder representations: () -> [Structure.Representation] = { [] },
                     @Structure.Reference.Builder associated: () -> [Structure.Reference] = { [] })
    {
        self.init()
        self.id = UUID(uuidString: id)!
        self.isStatic = true
        roleDescription = name
        canBeCreated = addToMenu
        let aspects = aspects()
        for i in 0 ..< aspects.count {
            aspects[i].index = i
        }
        self.aspects = aspects.asSet
        self.representations = representations().asSet
        self.subRoles = subRoles.asSet
        self.references = associated().asSet
        print("Built role \(name)")
    }

 
}
