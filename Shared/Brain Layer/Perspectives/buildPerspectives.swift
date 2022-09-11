//
//  Brain+buildPerspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
private func buildPerspectives(_ content: () -> [Perspective], _ perspectiveId: inout Int64, _ aspectId: inout Int64) -> [Perspective.ID: Perspective] {
    let content = content()
    var result: [Perspective.ID: Perspective] = [:]
    for perspective in content {
        perspectiveId -= 1
        perspective.id = perspectiveId
        for aspect in perspective.aspects {
            aspectId -= 1
            aspect.id = aspectId
            aspect.perspective = perspective
        }
        result[perspective.id] = perspective
    }
    return result
}

func buildPerspectives(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
    var perspectiveId: Perspective.ID = 0
    var aspectId: Aspect.ID = 0
    return buildPerspectives(content, &perspectiveId, &aspectId)
}

extension Dictionary where Key == Perspective.ID, Value == Perspective {
    func addGroup(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
        var perspectiveId = keys.min() ?? 0
        var aspectId = values.flatMap { $0.aspects.map { $0.id } }.min() ?? 0

        return self.merging(buildPerspectives(content, &perspectiveId, &aspectId)) { $1 }
    }
}
