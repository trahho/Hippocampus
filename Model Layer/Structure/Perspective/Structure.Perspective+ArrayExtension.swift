//
//  Structure.Perspective+ArrayExtension.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

extension Array where Element == Structure.Perspective {
    var referencingFirst: [Structure.Perspective] {
        sorted(by: { $0.allReferences.contains($1) })
    }

    var finalsFirst: [Structure.Perspective] {
        sorted(by: { $0.conforms(to: $1) })
    }
}
