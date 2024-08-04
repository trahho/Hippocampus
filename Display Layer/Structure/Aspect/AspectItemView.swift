//
//  AspectView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import SwiftUI

struct AspectItemView: View {
    // MARK: Properties

    @State var item: Information.Item
    @State var aspect: Structure.Aspect
    @State var appearance: Presentation.Appearance

    // MARK: Content

    var body: some View {
        switch aspect.kind {
        case .date:
            EmptyView()
        case .drawing:
            EmptyView()
        case .text:
            let binding = Binding(get: { aspect[String.self, item] ?? "" }, set: { aspect[String.self, item] = $0 })
            
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
