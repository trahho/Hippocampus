//
//  HorizontalLayoutView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI

struct HorizontalLayoutView: View {
    @State var item: Information.Item
    @State var elements: [Presentation.Space]
    @State var alignment: Presentation.Alignment
    @State var layout: Presentation.Layout
   @State var appearance: Presentation.Appearance


    var verticalAlignment: VerticalAlignment {
        switch alignment {
        case .leading:
            return .top
        case .center:
            return .center
        case .trailing:
            return .bottom
        default:
            return .center
        }
    }

    var body: some View {
        HStack(alignment: verticalAlignment) {
            ForEach(0 ..< elements.count, id: \.self) { index in
                let space = elements[index]
                switch space {
                case .full(let presentation):
                    ItemPresentationView(presentation: presentation, item: item, layout: layout, appearance: appearance)
                case .normal(let presentation):
                    ItemPresentationView(presentation: presentation, item: item, layout: layout, appearance: appearance)
                case .percent(let presentation, let percent):
                    ItemPresentationView(presentation: presentation, item: item, layout: layout, appearance: appearance)
                }
            }
        }
    }
}
