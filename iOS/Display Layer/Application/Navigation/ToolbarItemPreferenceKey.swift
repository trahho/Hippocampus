//
//  ToolbarItemPreferenceKey.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

struct ToolBarItemPreferenceKey: PreferenceKey {
    typealias Value = [ToolbarItem]
    
    static var defaultValue: Value = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
//        print("append \(nextValue().count) to \(value.count)")
        value.append(contentsOf: nextValue())
    }
}
