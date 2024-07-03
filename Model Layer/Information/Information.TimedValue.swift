//
//  Information.TimedValue.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.06.24.
//

import Foundation
import Smaug

extension Information {
    struct TimedValue: Codable {
        let date: Date
        let value: ValueStorage
    }
}

extension [Structure.Aspect.ID: Information.TimedValue]: Mergeable {
    public mutating func merge(other: any Mergeable) throws {
        guard let other = other as? Self else { return }
        for key in Set(self.keys).intersection(Set(other.keys)) {
            if let own = self[key], let other = other[key], own.date < other.date {
                self[key] = other
            }
        }

        for key in Set(other.keys).subtracting(Set(self.keys)) {
            self[key] = other[key]!
        }
    }
}
