//
//  Presentation.Alignment.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.05.24.
//

import Foundation
import Grisu
import SwiftUI

extension Presentation {
    enum Alignment: Structure.PersistentValue {

        case leading, center, trailing

        var horizontal: HorizontalAlignment {
            switch self {
            case .leading:
                .leading
            case .center:
                .center
            case .trailing:
                .trailing
            }
        }

        var vertical: VerticalAlignment {
            switch self {
            case .leading:
                .top
            case .center:
                .center
            case .trailing:
                .bottom
            }
        }
    }
}
