//
//  Structure.Aspect.Representation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.01.23.
//

import Foundation
import SwiftUI

extension Structure.Aspect {
    enum Presentation: Structure.PersistentValue {
        case text, drawing, date
        
        enum Form: Structure.PersistentValue {
            case icon, small, normal, firstParagraph, editFull, edit
        }

        @ViewBuilder
        func view(for item: Information.Item, in aspect: Structure.Aspect, as form: Form, editable: Bool) -> some View {
            switch self {
            case .text:
                TextView(item: item, aspect: aspect, form: form, editable: editable)
            case .drawing:
                DrawingView(item: item, aspect: aspect, form: form,  editable: editable)
            case .date:
                HStack { EmptyView() }
            }
        }
    }
}
