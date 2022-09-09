//
//  AspectStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.09.22.
//

import Foundation

protocol AspectStorage {
    subscript(_ key: Aspect.ID) -> Codable? {
        get set
    }
    
    func setValue(_ key: Aspect.ID, value: Codable?)
}
