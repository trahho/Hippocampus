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
//    enum Appearance: Structure.PersistentValue, PickableEnum {
//        case icon, small, normal, firstParagraph, full, edit
//
//        var description: String {
//            switch self {
//            case .icon:
//                "icon"
//            case .small:
//                "small"
//            case .normal:
//                "normal"
//            case .firstParagraph:
//                "firstParagraph"
//            case .full:
//                "full"
//            case .edit:
//                "edit"
//            }
//        }
//    }

    enum Kind: Structure.PersistentValue, PickableEnum {
        case text, drawing, date

        // MARK: Computed Properties

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

        var forms: [Form]? {
            switch self {
            case .date: [.date, .time, .weekday]
            default: nil
            }
        }
    }
}
