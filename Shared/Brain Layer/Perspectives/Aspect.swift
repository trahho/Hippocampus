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

    @PublishedSerialized var designation: String = ""
    @PublishedSerialized var representation: Representation
    @PublishedSerialized var defaultValue: Codable?
    var perspective: Perspective

    init(_ designation: String, _ representation: Representation, defaultValue: Codable? = nil) {
        super.init()
        self.designation = designation
        self.representation = representation
        self.defaultValue = defaultValue
    }

    required init() {}

    func compare<T: AspectStorage>(lhs: T, rhs: T) -> ComparisonResult {
        Aspect.compareValues(lhs: self[lhs], rhs: self[rhs])
    }

   static  func compareValues<T>(lhs: T?, rhs: T?) -> ComparisonResult {
        return .unknown
    }

   static func compareValues<T: Comparable>(lhs: T?, rhs: T?) -> ComparisonResult {
        if lhs == nil, rhs != nil { return .smaller }
        if lhs != nil, rhs == nil { return .larger }
        if lhs == rhs { return .equal }
        return lhs! < rhs! ? .smaller : .larger
    }

    subscript(_ storage: AspectStorage) -> Codable? {
        get { return storage[self] }
        set { storage[self] = newValue }
    }

//    func value<T: AspectStorage>(for storage: T) -> Codable? {
//        return storage[id]
//    }
//
//    func setValue<T: AspectStorage>(for storage: T, value: Codable?) {
//        storage.setValue(id, value: value)
//    }
}

extension Aspect {
    enum Representation {
        case text, drawing
    }
}

// extension Dictionary where Self.Key == Brain.Aspect.ID, Self.Value == Codable {
//
// }

// TODO: Collection von Frames, welche die Werte repräsentieren können. Frame kann einen davon wählen. Über Id.
