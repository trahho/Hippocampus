//
//  AspectView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import SwiftUI

struct AspectView: View {
    // MARK: Properties

    @State var item: Information.Item?
    @State var aspect: Structure.Aspect
    @State var appearance: Presentation.Appearance
    @State var editable: Bool
    @State var text: String = "Empty"

    // MARK: Computed Properties

    var textBinding: Binding<String> {
        if let item {
            Binding(get: { item[aspect, String.self] ?? "" }, set: { item[aspect, String.self] = $0 })
        } else {
            $text
        }
    }

    // MARK: Content

    var body: some View {
        switch aspect.kind {
        case .date:
            EmptyView()
        case .drawing:
            EmptyView()
        case .text:
            switch appearance {
            case .icon:
                Image(systemName: "text.word.spacing")
            case .full, .normal, .small:
                Text(textBinding.wrappedValue)
            case .firstParagraph:
                Text(textBinding.wrappedValue)
                    .lineLimit(1)
            case .edit:
                TextEditor(text: textBinding)
            case .inspector:
                LabeledContent {
//                    TextField("", text: textBinding)
//                        .frame(maxHeight: .infinity)
                    TextEditor(text: textBinding)
                } label: {
                    Text(aspect.name)
                }
            }
        }
//        switch (aspect.kind, appearance) {
//        case (let kind, .icon):
//            switch kind {
//            case .date:
//                Image(systemName: "calendar")
//            case .drawing:
//                Image(systemName: "theatermask.and.paintbrush")
//            case .text:
//                Image(systemName: "text.word.spacing")
//            }
        ////        case (.text, .firstParagraph):
        ////            if editable {
        ////                TextField("", text: textBinding)
        ////                    .lineLimit(1)
        ////            } else {
        ////                Text(verbatim: textBinding.wrappedValue)
        ////                    .lineLimit(1)
        ////            }
//        case (.text, _):
//            if editable {
//                TextField("", text: textBinding)
//            } else {
//                Text(verbatim: textBinding.wrappedValue)
//            }
//        default:
//            EmptyView()
//        }
//        switch aspect.kind {
//        case .text:
//            TextAspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
//        case .drawing:
//            DrawingAspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
//        case .date:
//            DateAspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
//        }
    }
}

// #Preview {
//    AspectView()
// }
