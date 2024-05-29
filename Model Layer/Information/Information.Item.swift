//
//  Information.Item+subscripts.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.01.23.
//

import Foundation
import Smaug

extension [Structure.Aspect.ID: Information.Item.TimedValue]: Mergeable {
    public mutating func merge(other: any Mergeable) throws {
        guard let other = other as? Self else { return }
        Set(self.keys).intersection(Set(other.keys))
            .forEach { key in
                if let own = self[key], let other = other[key], own.date < other.date {
                    self[key] = other
                }
            }

        Set(other.keys).subtracting(Set(self.keys))
            .forEach { key in
                self[key] = other[key]!
            }
    }
}

extension Information {
    class Item: Object {
        typealias Value = ValueStorage.PersistentValue

        struct TimedValue: Codable {
            let date: Date
            let value: ValueStorage
        }

        @Property var deleted: Bool = false
        @Objects var roles: [Structure.Role]

        @Objects var to: [Item]
        @Relations(\Self.to) var from: [Item]

        @Property private var values: [Structure.Aspect.ID: TimedValue] = [:]
        
        var presentRoles: [Structure.Role] {
            values.keys.compactMap { self[Structure.Aspect.self, $0]?.role }.asSet.asArray
        }

        subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect) -> T? where T: Value {
            get {
                guard let timedValue = values[aspect.id], let value = timedValue.value.value as? T? else { return aspect.kind.defaultValue as? T }
                return value
            }
            set {
                self.values[aspect.id] = TimedValue(date: writingTimestamp, value: ValueStorage(newValue)!)
            }
        }

        subscript(_ aspectId: Structure.Aspect.ID) -> ValueStorage? {
            self.values[aspectId]?.value
        }
//        subscript(role role: Structure.Role) -> Bool {
//            get {
//                roles.contains(role)
//            }
//            set {
//                if newValue == true {
//                    let allRoles = role.allRoles
//                    if !roles.isSuperset(of: allRoles) {
//                        roles = roles.union(allRoles)
//                    }
//                } else {
//                    roles.remove(role)
//                }
//            }
//        }

//        subscript(role role: Structure.Role.ID) -> Bool {
//            get {
//                self[role: self[Structure.Role.self, role]!]
//            }
//            set {
//                self[role: self[Structure.Role.self, role]!] = newValue
//            }
//        }
//
//        subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect) -> T? where T: Information.PersistentValue {
//            get {
//                self[type, aspect.id.key]
//            }
//            set {
//                self[type, aspect.id.key] = newValue
//                self[role: aspect.role] = true
//            }
//        }
    }
}
