//
//  Information.Particle.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.06.24.
//

import Foundation
import Smaug

extension Information {
    class Particle: ObjectPersistence.Object, Aspectable {
        // MARK: Nested Types

        typealias Value = ValueStorage.PersistentValue

        // MARK: Properties

        @Property var particle: Structure.Particle.ID!

        @Property private var values: [Structure.Aspect.ID: TimedValue] = [:]

        // MARK: Functions

        subscript(_ aspectId: Structure.Aspect.ID) -> Structure.Aspect.Value? {
            get {
                Structure.Aspect.Value(values[aspectId]?.value)
            }
            set {
                values[aspectId] = TimedValue(date: .now, value: newValue?.valueStorage ?? .nil)
            }
        }

        subscript(_ aspect: Structure.Aspect) -> Structure.Aspect.Value? {
            get { aspect[self] }
            set { aspect[self] = newValue }
        }

        subscript<T>(_ aspect: Structure.Aspect, _ type: T.Type) -> T? where T: Information.Value {
            get { aspect[type, self] }
            set { aspect[type, self] = newValue }
        }
    }
}
