//
//  VerticalLayoutView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI


struct VerticalLayoutView: View {
    @State var item: Information.Item
    @State var elements: [Presentation.Space]
    @State var alignment: Presentation.Alignment

    var horizontalAlignment: HorizontalAlignment {
        switch alignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            return .center
        }
    }
    
    var body: some View {
        VStack(alignment: horizontalAlignment) {
            ForEach(0 ..< elements.count, id: \.self) { index in
                let space = elements[index]
                switch space {
                case .full(let presentation):
                    ItemPresentationView(presentation: presentation, item: item)
                case .normal(let presentation):
                    ItemPresentationView(presentation: presentation, item: item)
                case .percent(let presentation, let percent):
                    ItemPresentationView(presentation: presentation, item: item)
                }
            }
        }
    }

}

