//
//  Brain+buildPerspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation

func buildPerspectives(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
    content().asDictionary(key: \.id)
}

// func buildPerspectives(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
//    var perspectiveId: Perspective.ID = 0
//    return buildPerspectives(content, &perspectiveId)
// }

extension Dictionary where Key == Perspective.ID, Value == Perspective {
    func addGroup(_ title: String, @Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
//        var perspectiveId = keys.min() ?? 0
//        var aspectId = values.flatMap { $0.aspects.map { $0.id } }.min() ?? 0

        return merging(buildPerspectives(content)) { $1 }
    }
}
