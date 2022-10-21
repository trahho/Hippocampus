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
    @Serialized var defaultValue: Codable?
    var perspective: Perspective!

    init(_ designation: String, _ representation: Representation, defaultValue: Codable? = nil) {
        super.init()
        self.designation = designation
        self.representation = representation
        self.defaultValue = defaultValue
    }

    required init() {}

//    func compare<T: AspectStorage>(lhs: T, rhs: T) -> ComparisonResult {
//        Aspect.compareValues(lhs: self[lhs], rhs: self[rhs])
//    }
//
    //   static  func compareValues<T>(lhs: T?, rhs: T?) -> ComparisonResult {
//        return .unknown
//    }
//
    //   static func compareValues<T: Comparable>(lhs: T?, rhs: T?) -> ComparisonResult {
//        if lhs == nil, rhs != nil { return .smaller }
//        if lhs != nil, rhs == nil { return .larger }
//        if lhs == rhs { return .equal }
//        return lhs! < rhs! ? .smaller : .larger
//    }

    subscript<T: Codable>(_ storage: any AspectStorage) -> T? {
        get { return storage[self.id] as? T ?? self.defaultValue as? T }
        set {
            storage[self.id] = newValue
        }
    }

    subscript<T: Codable>(_ storage: any AspectStorage, _ defaultValue: T) -> T { return self[storage] ?? defaultValue }

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
