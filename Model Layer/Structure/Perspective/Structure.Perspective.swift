//
//  Perspective.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Grisu
import Smaug
import SwiftUI

extension Structure {
//    @dynamicMemberLookup
    class Perspective: Object, EditableListItem, Pickable {
        // MARK: Properties

        @Property var name = ""
        @Objects var perspectives: [Perspective]
        @Objects(deleteReferences: true) var aspects: [Aspect]
        @Objects(deleteReferences: true) var particles: [Particle]

        @Relations(\Perspective.perspectives) var subPerspectives: [Perspective]
        @Objects var references: [Perspective]
        @Relations(\Perspective.references) var referencedBy: [Perspective]
        @Property var representations: [Representation] = []

        // MARK: Computed Properties

        var description: String {
            name.localized(isStatic)
        }

        var allPerspectives: [Perspective] {
            (perspectives.flatMap { $0.allPerspectives } + [self]).asSet.asArray
        }

        var allReferences: [Perspective] {
            references.asSet.union(perspectives.flatMap { $0.allReferences }.map { self.conforms(to: $0) ? self : $0 }).asArray
        }

        var allReferencedBy: [Perspective] {
            referencedBy.asSet.union(perspectives.flatMap { $0.allReferencedBy }.map { self.conforms(to: $0) ? self : $0 }).asArray
        }

        var allAspects: [Aspect] {
            var result: [Aspect] = []
            for perspective in perspectives {
                for aspect in perspective.allAspects {
                    if !result.contains(aspect) {
                        result.append(aspect)
                    }
                }
            }
            result.append(contentsOf: aspects)
            return result
        }

        // MARK: Functions

//        subscript(dynamicMember dynamicMember: String) -> Aspect {
//            if let result = aspects.first(where: { $0.name.lowercased() == dynamicMember.lowercased() }) {
//                return result
//            } else {
//                return perspectives.compactMap { $0[dynamicMember: dynamicMember] }.first!
//            }
//        }
//
//        subscript(dynamicMember dynamicMember: String) -> Particle {
//            if let result = particles.first(where: { $0.name.lowercased() == dynamicMember.lowercased() }) {
//                return result
//            } else {
//                return perspectives.compactMap { $0[dynamicMember: dynamicMember] }.first!
//            }
//        }

        func representation(layout: Presentation.Layout, name: String? = nil) -> Representation? {
//            print("Checking for \(self.name)")
            if let result = representations.first(where: { $0.layouts.contains(layout) && $0.name == name ?? $0.name }) {
//                print("Found it!")
                return result
            }
            var perspectives = self.perspectives
            while !perspectives.isEmpty {
                var nextPerspectives = [Perspective]()
//                print("Next perspectives: \(perspectives.map { $0.name }.joined(separator: ", "))")
                for perspective in perspectives {
//                    print("Checking for \(perspective.name)")
                    if let result = perspective.representations.first(where: { $0.layouts.contains(layout) && $0.name == name ?? $0.name }) {
//                        print("Found it!")
                        return result
                    }
                    for perspective in perspective.perspectives {
                        if !nextPerspectives.contains(perspective) {
                            nextPerspectives.append(perspective)
                        }
                    }
                }
                perspectives = nextPerspectives
                nextPerspectives = []
            }
            return nil
//            allPerspectives
//                .finalsFirst
//                .flatMap {
//                    $0.representations.filter {
//                        $0.layouts.contains(layout) && $0.name == name ?? $0.name
//                    }
//                }
//                .first
        }

//            if let representation = representations.first(where: { $0.layouts.contains(layout) && $0.name == name ?? $0.name }) {
//                return representation.presentation
//            } else {
//                return allPerspectives.filter { $0.conforms(to: perspective) }
//                    .finalsFirst
//                    .compactMap { $0.presentation(for: perspective, layout: layout, name: name)}
//                    .first!
//            }
//
//        }

        func conforms(to perspective: Perspective) -> Bool {
            perspective == self || !perspectives.filter { $0.conforms(to: perspective) }.isEmpty
        }
    }
}
