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
//        preference(key: ToolBarItemPreferenceKey.self, value: [ToolbarItem(placement: placement, view: AnyView(item()))])
        transformPreference(ToolBarItemPreferenceKey.self) { items in
            items = items + [ToolbarItem(placement: placement, view: AnyView(item()))]
        }
    }
}
