//
//  PersistentData.Object+getKey.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.12.22.
//

import Foundation

extension PersistentData.Object {
    func getKey<T: AnyObject>(for value: T) -> String {
        var mirror: Mirror? = Mirror(reflecting: self)
        repeat {
            guard let children = mirror?.children else { break }
            for child in children {
                if let wrapper = child.value as? T, wrapper === value {
                    return String((child.label ?? "").dropFirst())
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil

        return ""
    }
}
