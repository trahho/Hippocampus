//
//  Information.Item+subscripts.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.01.23.
//

import Foundation
import Smaug

protocol Conditionable {
    func matches(_ condition: Information.Condition) -> Bool
}

extension Information {
    class Item: Object, Aspectable {
        // MARK: Properties

        // MARK: Internal

        @Property var deleted: Bool = false
        @Objects var perspectives: [Structure.Perspective]
        @Property var particles: [Particle] = []
        @Objects var to: [Item]
        @Relations(\Self.to) var from: [Item]

        // MARK: Private

        @Property private var values: [Structure.Aspect.ID: TimedValue] = [:]

        // MARK: Computed Properties

        var allChildren: [Item] {
            var cache: Set<Item> = []
            allChildren(cache: &cache)
            cache.remove(self)
            return cache.asArray
        }

        // MARK: Functions

        func matchingPerspective(for perspective: Structure.Perspective) -> Structure.Perspective? {
            return perspectives.first { $0.conforms(to: perspective) }
        }

        subscript(_ aspectId: Structure.Aspect.ID) -> Structure.Aspect.Value {
            get {
                Structure.Aspect.Value(values[aspectId]?.value)
            }
            set {
                values[aspectId] = TimedValue(date: writingTimestamp, value: newValue.storage ?? .nil)
            }
        }

        subscript(_ aspect: Structure.Aspect, form: Structure.Aspect.Kind.Form?) -> Structure.Aspect.Value {
            get { aspect[self, form] }
            set { aspect[self, form] = newValue }
        }

        subscript<T>(_ aspect: Structure.Aspect, _ type: T.Type, form: Structure.Aspect.Kind.Form? = nil) -> T? where T: Information.Value {
            get { aspect[type, self, form] }
            set { aspect[type, self, form] = newValue }
        }

        private func allChildren(cache: inout Set<Item>) {
            guard !cache.contains(self) else { return }
            cache = cache.union(to)
            to.forEach { $0.allChildren(cache: &cache) }
        }
    }
}
