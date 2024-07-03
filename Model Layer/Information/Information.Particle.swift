//
//  Information.Particle.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.06.24.
//

import Foundation
import Smaug

extension Information {
    class Particle: ObjectPersistence.Object {
        typealias Value = ValueStorage.PersistentValue

        @Property var particle: Structure.Particle.ID!
        @Property private var values: [Structure.Aspect.ID: TimedValue] = [:]

        subscript(_ aspectId: Structure.Aspect.ID) -> ValueStorage? {
            get {
                self.values[aspectId]?.value
            }
            set {
                self.values[aspectId] = TimedValue(date: .now, value: newValue ?? .nil)
            }
        }

        subscript(_ aspect: Structure.Aspect) -> ValueStorage? {
            get { aspect[self] }
            set { aspect[self] = newValue }
        }

        subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect) -> T? where T: Information.Value {
            get { aspect[type, self] }
            set { aspect[type, self] = newValue }
        }
    }
}
