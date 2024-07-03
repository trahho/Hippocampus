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
    class Item: Object {
        @Property var deleted: Bool = false
        @Objects var roles: [Structure.Role]
        @Property var particles: [Particle] = []
        @Objects var to: [Item]
        @Relations(\Self.to) var from: [Item]

        @Property private var values: [Structure.Aspect.ID: TimedValue] = [:]

        func conforms(to role: Structure.Role) -> Bool {
            return self.roles.first { $0.conforms(to: role) } != nil
        }

        private func allChildren(cache: inout Set<Item>) {
            guard !cache.contains(self) else { return }
            cache = cache.union(self.to)
            self.to.forEach { $0.allChildren(cache: &cache) }
        }

        var allChildren: [Item] {
            var cache: Set<Item> = []
            allChildren(cache: &cache)
            cache.remove(self)
            return cache.asArray
        }

        subscript(_ aspectId: Structure.Aspect.ID) -> ValueStorage? {
            get {
                self.values[aspectId]?.value
            }
            set {
                self.values[aspectId] = TimedValue(date: writingTimestamp, value: newValue ?? .nil)
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
