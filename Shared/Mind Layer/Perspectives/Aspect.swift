//
//  Brain.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation
import SwiftUI

class Aspect: PersistentObject {
    typealias ComparableCodable = Codable & Comparable

    @Serialized var designation: String = ""
    @Serialized var representation: Representation
    @Serialized var defaultValue: Point
    var perspective: Perspective!

    init(_ designation: String, _ representation: Representation, defaultValue: Point = .empty) {
        super.init()
        self.designation = designation
        self.representation = representation
        self.defaultValue = defaultValue
    }

    required init() {}

//    func compare<T: AspectStorage>(lhs: T, rhs: T) -> AspectComparisonResult {
//        Aspect.compareValues(lhs: self[lhs] as? Codable, rhs: self[rhs] as? Codable)
//    }
//
//    static func compareValues<T>(lhs: T?, rhs: T?) -> AspectComparisonResult {
//        return .unknown
//    }
//
//    static func compareValues<T: Comparable>(lhs: T?, rhs: T?) -> AspectComparisonResult {
//        if lhs == nil, rhs != nil { return .smaller }
//        if lhs != nil, rhs == nil { return .larger }
//        if lhs == rhs { return .equal }
//        return lhs! < rhs! ? .smaller : .larger
//    }

    subscript(_ storage: any AspectStorage) -> Point {
        get {
            storage[self.id].gettingToThePoint(self.defaultValue)
        }
        set {
            let moment = Date()
            if storage[self.perspective.created.id] == .empty {
                storage[self.perspective.created.id] = .date(moment)
            }
            storage[self.perspective.modified.id] = .date(moment)
            storage[self.id] = newValue
        }
    }

    subscript(_ storage: any AspectStorage, _ defaultValue: Point = .empty) -> Point {
        storage[self.id].gettingToThePoint(defaultValue.gettingToThePoint(self.defaultValue))
    }

//    func value<T: AspectStorage>(for storage: T) -> Codable? {
//        return storage[id]
//    }
//
//    func setValue<T: AspectStorage>(for storage: T, value: Codable?) {
//        storage.setValue(id, value: value)
//    }
}

// extension Dictionary where Self.Key == Brain.Aspect.ID, Self.Value == Codable {
//
// }

// TODO: Collection von Frames, welche die Werte repräsentieren können. Frame kann einen davon wählen. Über Id.
