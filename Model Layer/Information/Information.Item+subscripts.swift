//
//  Information.Item+subscripts.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.01.23.
//

import Foundation

extension Information.Item {
    subscript(role role: Structure.Role, timestamp timestamp: Date? = nil) -> Bool {
        get {
            self[role: role.id, timestamp: readingTimestamp]
        }
        set {
            if newValue == true {
                role.allRoles.forEach { role in
                    self[role: role.id, timestamp: writingTimestamp(timestamp)] = true
                }
            } else {
                self[role: role.id, timestamp: writingTimestamp(timestamp)] = false
            }
        }
    }

    subscript<T>(_ type: T.Type, _ aspect: Structure.Aspect, timestamp: Date? = nil) -> T? where T: Information.PersistentValue {
        get {
            self[type, aspect.id, timestamp: readingTimestamp]
        }
        set {
            let timestamp = writingTimestamp(timestamp)
            self[type, aspect.id, timestamp: timestamp] = newValue
            self[role: aspect.role.id, timestamp: timestamp] = true
        }
    }
}
