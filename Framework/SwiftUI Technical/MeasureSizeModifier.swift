//
//  GetSizeModifier.swift
//  GraphLayout
//
//  Created by Guido Kühn on 18.03.22.
//

import Foundation
import SwiftUI

extension View {
    func onSizeChanged(action: @escaping (CGSize) -> Void) -> some View {
        self
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewSizePreferenceKey.self, value: geometry.size)
                }
            }
            .onPreferenceChange(ViewSizePreferenceKey.self) { newValue in
                action(newValue)
            }
    }

    func measureSize(in storage: Binding<CGSize>) -> some View {
        self
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewSizePreferenceKey.self, value: geometry.size)
                }
            }
            .onPreferenceChange(ViewSizePreferenceKey.self) { newValue in
                storage.wrappedValue = newValue
            }
    }
}

struct ViewSizePreferenceKey: PreferenceKey {
    typealias Value = CGSize

    static var defaultValue = CGSize.zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}


