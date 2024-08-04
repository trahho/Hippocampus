//
//  AspectView.AspectText.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI

struct TextAspectView: View {
    // MARK: Properties

    @Binding var text: String
    @State var appearance: Presentation.Appearance

    // MARK: Content

    var body: some View {
        switch appearance {
        case .icon:
            Image(systemName: "text.word.spacing")
        case .full, .normal, .small:
            Text(text)
                .lineLimit(nil)
        case .firstParagraph:
            Text(text)
                .lineLimit(1)
        case .edit, .inspector:
            TextField("", text: $text)
        }
    }
}
