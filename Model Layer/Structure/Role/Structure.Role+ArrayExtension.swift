//
//  Structure.Role+ArrayExtension.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

extension Array where Element == Structure.Role {
    var referencingFirst: [Structure.Role] {
        sorted(by: { $0.allReferences.contains($1) })
    }

    var finalsFirst: [Structure.Role] {
        sorted(by: { $0.conforms(to: $1) })
    }
}
