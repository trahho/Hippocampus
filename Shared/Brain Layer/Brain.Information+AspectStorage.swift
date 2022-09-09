////
////  Brain.Information+AspectStorage.swift
////  Hippocampus
////
////  Created by Guido Kühn on 04.09.22.
////
//
//import Foundation
//
//extension Brain.Information: AspectStorage {
//    func setValue(_ key: Aspect.ID, value: Codable?) {
//        aspects[key] = value
//    }
//
//    subscript(_ key: Aspect.ID) -> Codable? {
//        get {
//            aspects[key]
//        }
//        set {
//            aspects[key] = newValue
//        }
//    }
//
//    subscript(_ aspect: Aspect) -> Codable? {
//        get {
//            aspects[aspect.id]
//        }
//        set {
//            aspects[aspect.id] = newValue
//        }
//    }
//}
