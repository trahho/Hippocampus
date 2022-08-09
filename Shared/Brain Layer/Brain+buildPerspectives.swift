//
//  Brain+buildPerspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
extension Brain {
    static func buildPerspectives(@Brain.Perspective.Builder _ content: () -> [Perspective]) -> [Perspective] {
        var perspectiveId: Perspective.ID = 0
        var aspectId: Aspect.ID = 0
        let result = content()
        for perspective in result {
            perspectiveId -= 1
            perspective.id = perspectiveId
            for aspect in perspective.aspects {
                aspectId -= 1
                aspect.id = aspectId
            }
        }
        return result
    }
}

extension Array where Array.Element == Brain.Perspective {
    func addGroup(@Brain.Perspective.Builder _ content: () -> [Brain.Perspective]) -> [Brain.Perspective] {
        var perspectiveId = (last?.id ?? 0)
        var aspectId = (last?.aspects.last?.id ?? 0)
        let result = content()
        for perspective in result {
            perspectiveId -= 1
            perspective.id = perspectiveId
            for aspect in perspective.aspects {
                aspectId -= 1
                aspect.id = aspectId
            }
        }
        return self + result
    }
}
