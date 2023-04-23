//
//  ToolbarItem.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

struct ToolbarItem: Identifiable, Equatable {
    static func == (lhs: ToolbarItem, rhs: ToolbarItem) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    let placement: ToolbarItemPlacement
    let view: AnyView
}
