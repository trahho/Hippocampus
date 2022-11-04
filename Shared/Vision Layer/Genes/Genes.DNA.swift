//
//  Genes.DNA.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation

extension Genes {
    final class DNA: Serializable, ObservableObject {
        static let origin: DNA = {
            let result = DNA()
            result.strength = .normal
            result.editable = false
            return result
        }()

        @PublishedSerialized var strength: Sensation.ReceptionStrength?
        @PublishedSerialized var editable: Bool?
    }
}
