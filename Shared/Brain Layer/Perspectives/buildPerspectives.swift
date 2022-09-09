//
//  Brain+buildPerspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
func buildPerspectives(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
    var perspectiveId: Perspective.ID = 0
    var aspectId: Aspect.ID = 0
    let content = content()
    var result: [Perspective.ID: Perspective] = [:]
    for perspective in content {
        perspectiveId -= 1
        perspective.id = perspectiveId
        for aspect in perspective.aspects {
            aspectId -= 1
            aspect.id = aspectId
        }
        result[perspective.id] = perspective
    }
    return result
}

extension Dictionary where Key == Perspective.ID, Value == Perspective {
    func addGroup(@Perspective.Builder _ content: () -> [Perspective]) -> [Perspective.ID: Perspective] {
        var perspectiveId = keys.min() ?? 0
        var aspectId = values.flatMap { $0.aspects.map { $0.id } }.min() ?? 0
        let content = content()
        var result: [Perspective.ID: Perspective] = [:]
        for perspective in content {
            perspectiveId -= 1
            perspective.id = perspectiveId
            for aspect in perspective.aspects {
                aspectId -= 1
                aspect.id = aspectId
            }
            result[perspective.id] = perspective
        }
        return self.merging(result) { $1 }

//        return self.merging(result) { old, _ in old }
    }
}
