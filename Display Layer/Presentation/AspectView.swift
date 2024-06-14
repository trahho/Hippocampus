//
//  AspectView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import SwiftUI

struct AspectView: View {
    @State var item: Information.Item
    @State var aspect: Structure.Aspect
    @State var appearance: Presentation.Appearance
    @State var editable: Bool

    var body: some View {
        switch aspect.kind {
        case .text:
            TextAspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
        case .drawing:
            DrawingAspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
        case .date:
            DateAspectView(item: item, aspect: aspect, appearance: appearance, editable: editable)
        }
    }
}

// #Preview {
//    AspectView()
// }
