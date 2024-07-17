//
//  Presentation.Space.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.07.24.
//

import Foundation
import Grisu

extension Presentation {
    enum Space: Structure.PersistentValue, PickableEnum, SourceCodeGenerator {
        case normal
        case percent(Double, alignment: Presentation.Alignment)
        case full(alignment: Presentation.Alignment)

        // MARK: Static Computed Properties

        static var allCases: [Presentation.Space] { [.normal, .percent(0.3, alignment: .center), .percent(0.5, alignment: .center), .percent(0.75, alignment: .center), .full(alignment: .center)] }

        // MARK: Computed Properties

        var description: String {
            switch self {
            case .normal:
                return "Normal"
            case let .percent(value, _):
                return "\(value * 100)%"
            case .full:
                return "Full"
            }
        }

        var factor: Double {
            switch self {
            case .normal:
                return 0
            case .full:
                return 1
            case let .percent(percent, _):
                return percent
            }
        }

        var alignment: Presentation.Alignment {
            switch self {
            case .normal:
                return .center
            case let .full(alignment), let .percent(_, alignment):
                return alignment
            }
        }

        // MARK: Functions

        func sourceCode(tab _: Int, inline: Bool, document: Document) -> String {
            switch self {
            case .normal:
                return ".normal"
            case let .percent(value, alignment):
                return ".percent(\(value), alignment: \(alignment.sourceCode(tab: 0, inline: true, document: document)))"
            case .full:
                return ".full(alignment: \(alignment.sourceCode(tab: 0, inline: true, document: document)))"
            }
        }
    }
}
