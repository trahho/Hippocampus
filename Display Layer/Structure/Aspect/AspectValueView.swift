//
//  AspectItemView 2.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.08.24.
//

import SwiftUI

struct AspectValueView: View {
    // MARK: Properties

    @State var aspect: Structure.Aspect
    @Binding var value: Information.ValueStorage
    @State var appearance: Presentation.Appearance

    // MARK: Content

    var body: some View {
        switch aspect.kind {
        case .date:
            EmptyView()
        case .drawing:
            EmptyView()
        case .text:
            let binding = Binding(get: { value.value as? String ?? "" }, set: { value = .init($0) ?? .nil })
            switch appearance {
            case .inspector:
                LabeledContent {
                    TextAspectView(text: binding, appearance: appearance)
                } label: {
                    Text(aspect.name)
                }
            default:
                TextAspectView(text: binding, appearance: appearance)
            }
        }
    }
}
