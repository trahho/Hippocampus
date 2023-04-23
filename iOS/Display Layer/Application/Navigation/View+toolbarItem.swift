//
//  View+toolbarItem.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

extension View {
    func toolbarItem(placement: ToolbarItemPlacement, item: @escaping () -> some View) -> some View {
        transformPreference(ToolBarItemPreferenceKey.self) { items in
//            print("\(placement)")
            items = items + [ToolbarItem(placement: placement, view: AnyView(item()))]
        }
    }
}
