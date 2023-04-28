//
//  PersistentData.Object.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Combine
import Foundation

extension PersistentData {
    open class Object: PersistentObject, ObservableObject {
        var data: PersistentData?
    }
}
