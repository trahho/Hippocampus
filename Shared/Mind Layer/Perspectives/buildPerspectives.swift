//
//  Brain+buildPerspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation

private func buildPerspectives(_ content: () -> [Perspective], _ perspectiveId: inout Perspective.ID) -> [Perspective.ID: Perspective] {
    let content = content()
    var result: [Perspective.ID: Perspective] = [:]
    for perspective in content {
        perspectiveId -= 1
        var aspectId = perspectiveId * 100 - 2
        perspective.id = perspectiveId
        result[perspective.id] = perspective
        for aspect in perspective.aspects.filter({ $0.id == 0 }) {
            aspectId -= 1
            aspect.id = aspectId
            aspect.perspective = perspective
        }
    }
    return result
}

func buildPerspectives(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
    var perspectiveId: Perspective.ID = 0
    return buildPerspectives(content, &perspectiveId)
}

extension Dictionary where Key == Perspective.ID, Value == Perspective {
    func addGroup(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
        var perspectiveId = keys.min() ?? 0
//        var aspectId = values.flatMap { $0.aspects.map { $0.id } }.min() ?? 0

        return merging(buildPerspectives(content, &perspectiveId)) { $1 }
    }
}
