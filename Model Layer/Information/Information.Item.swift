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
        @Objects var roles: [Structure.Role]
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

        func matchingRole(for role: Structure.Role) -> Structure.Role? {
            return roles.first { $0.conforms(to: role) }
        }

        subscript(_ aspectId: Structure.Aspect.ID) -> Structure.Aspect.Value? {
            get {
                Structure.Aspect.Value(values[aspectId]?.value)
            }
            set {
                values[aspectId] = TimedValue(date: writingTimestamp, value: newValue?.valueStorage ?? .nil)
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

        private func allChildren(cache: inout Set<Item>) {
            guard !cache.contains(self) else { return }
            cache = cache.union(to)
            to.forEach { $0.allChildren(cache: &cache) }
        }
    }
}
