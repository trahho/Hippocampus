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

        enum Form {
//            case icon, small, normal, firstParagraph, editFull, edit
            static let icon = "_form-Icon"
            static let small = "_form-Small"
            static let normal = "_form-Normal"
            static let firstParagraph = "_form-FirstParagraph"
            static let edit = "_form-Edit"

        }

        var defaultValue: (any Structure.PersistentValue)? {
            switch self {
            case .date:
                return Date()
            default:
                return nil
            }
        }

        @ViewBuilder
        func view(for item: Information.Item, in aspect: Structure.Aspect, as form: String, editable: Bool) -> some View {
            switch self {
            case .text:
                TextView(item: item, aspect: aspect, form: form, editable: editable)
            case .drawing:
                DrawingView(item: item, aspect: aspect, form: form, editable: editable)
            case .date:
                HStack { EmptyView() }
            }
        }
    }
}
