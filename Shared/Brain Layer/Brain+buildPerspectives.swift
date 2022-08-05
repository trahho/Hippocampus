//
//  Brain+buildPerspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.08.22.
//

import Foundation
extension Brain {
    static func buildPerspectives(@Brain.Perspective.Builder _ content: () -> [Perspective]) -> [Perspective] {
        var perspectiveId = -1
        var aspectId = -1
        let result = content()
        for perspective in result {
            perspective.id = perspectiveId
            perspectiveId -= 1
            for aspect in perspective.aspects {
                aspect.id = aspectId
                aspectId -= 1
            }
        }
        return result
    }
}

extension Array where Array.Element == Brain.Perspective {
    func addGroup(@Brain.Perspective.Builder _ content: () -> [Brain.Perspective]) -> [Brain.Perspective] {
        var perspectiveId = (self.last?.id ?? 0) - 1
        var aspectId = (self.last?.aspects.last?.id ?? 0) - 1
        let result = content()
        for perspective in result {
            perspective.id = perspectiveId
            perspectiveId -= 1
            for aspect in perspective.aspects {
                aspect.id = aspectId
                aspectId -= 1
            }
        }
        return self + result
    }
}
