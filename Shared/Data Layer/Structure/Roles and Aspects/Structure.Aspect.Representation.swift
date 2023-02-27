//
//  Structure.Aspect.Representation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.01.23.
//

import Foundation
import SwiftUI

extension Structure.Aspect {
    enum Representation: Structure.PersistentValue {
        case text, drawing, date

        @ViewBuilder
        func view(for item: Information.Item, in aspect: Structure.Aspect, editable: Bool) -> some View {
            switch self {
            case .text:
                TextView(item: item, aspect: aspect, editable: editable)
            case .drawing:
                DrawingView(item: item, aspect: aspect, editable: editable)
            case .date:
                HStack { EmptyView() }
            }
        }
    }
}
