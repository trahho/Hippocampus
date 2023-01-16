//
//  Thing.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.09.22.
//

import Combine
import Foundation

extension Mind {
    class Thing: IdentifiableObject, AspectStorage, ObservableObject {
        var brain: Brain
        var information: Brain.Information
        var cancellable: AnyCancellable?

        let perspectives: Set<Perspective>

        init(brain: Brain, information: Brain.Information, perspectives: Set<Perspective>) {
            self.brain = brain
            self.information = information
            self.perspectives = perspectives
            super.init()
            cancellable = self.information.objectWillChange.sink {
                self.objectWillChange.send()
            }
        }

        subscript(id: Aspect.ID) -> Aspect.Point {
            get {
                information[id]
            }
            set {
                information[id] = newValue
            }
        }

        override var id: IdentifiableObject.ID {
            get {
                information.id
            }
            set {}
        }

        func takesPerspective(_ id: Perspective.ID) -> Bool {
            perspectives.contains { $0.id == id }
        }

        func takePerspective(_: Perspective.ID) {}
    }
}
