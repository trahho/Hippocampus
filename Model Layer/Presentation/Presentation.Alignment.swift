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
    enum Alignment: Structure.PersistentValue, SourceCodeGenerator {
        case leading, center, trailing

        // MARK: Computed Properties

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

        // MARK: Functions

        func sourceCode(tab _: Int, inline _: Bool, document _: Document) -> String {
            switch self {
            case .leading:
                return ".leading"
            case .center:
                return ".center"
            case .trailing:
                return ".trailing"
            }
        }
    }
}
