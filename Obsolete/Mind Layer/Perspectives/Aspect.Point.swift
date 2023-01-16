//
//  Aspect.Point.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 17.11.22.
//

import Foundation

extension Aspect {
    enum Point: Codable, Equatable, Comparable {
        case empty
        case int(Int)
        case string(String)
        case date(Date)

        func gettingToThePoint(_ point: Point) -> Point {
            self == .empty ? point : self
        }

        func gettingToThePoint(_ string: String) -> Point {
            self == .empty ? .string(string) : self
        }
    }
}
