//
//  Presentation.Appearance.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.06.24.
//

import Foundation
import Grisu

extension Presentation {
    enum Appearance: Structure.PersistentValue, PickableEnum, SourceCodeGenerator {
        func sourceCode(tab i: Int, inline: Bool, document: Document) -> String {
            ".\(self.description)"
        }
        
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
}
