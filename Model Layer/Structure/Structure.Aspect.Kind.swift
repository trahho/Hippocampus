//
//  Structure.Aspect.Representation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.01.23.
//

import Foundation
import Grisu
import SwiftUI

extension Structure.Aspect {
    enum Presentation: Structure.PersistentValue, PickableEnum {
        case icon, small, normal, firstParagraph, full, edit
        
        var description: String {
            switch self {
            case .icon:
                "icon"
            case .small:
                "small"
            case .normal:
                "normal"
            case .firstParagraph:
                "firstParagraph"
            case .full:
                "full"
            case .edit:
                "edit"
            }
        }
    }

    enum Kind: Structure.PersistentValue, PickableEnum {
        case text, drawing, date

        var description: String {
            switch self {
            case .text:
                "text"
            case .drawing:
                "drawing"
            case .date:
                "date"
            }
        }

        var defaultValue: (any Structure.PersistentValue)? {
            switch self {
            case .date:
                return Date()
            default:
                return nil
            }
        }

        var type: Any.Type {
            switch self {
            case .text:
                String.self
            case .drawing:
                String.self
            case .date:
                Date.self
            }
        }

//        @ViewBuilder
//        func view(for item: Information.Item, in aspect: Structure.Aspect, as form: String, editable: Bool) -> some View {
//            switch self {
//            case .text:
//                TextView(item: item, aspect: aspect, form: form, editable: editable)
//            case .drawing:
//                DrawingView(item: item, aspect: aspect, form: form, editable: editable)
//            case .date:
//                HStack { EmptyView() }
//            }
//        }
    }
}
