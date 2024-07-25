//
//  AspectView.AspectText.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI

extension AspectView {
    struct TextAspectView: View {
        @State var item: Information.Item
        @State var aspect: Structure.Aspect
        @State var appearance: Presentation.Appearance
        @State var editable: Bool

        var textBinding: Binding<String> {
            Binding(get: { aspect[String.self, item] ?? "Not found" }, set: {  aspect[String.self, item] = $0 })
        }

        var body: some View {
            switch appearance {
            case .icon:
                Image(systemName: "text.word.spacing")
            case .small, .full, .normal, .edit:
                if editable {
                    TextField("", text: textBinding)
                } else {
                    Text(verbatim: textBinding.wrappedValue)
                }
            case .firstParagraph:
                if editable {
                    TextField("", text: textBinding)
                        .lineLimit(1)
                } else {
                    Text(verbatim: textBinding.wrappedValue)
                        .lineLimit(1)
                }
            }
        }
    }
}
