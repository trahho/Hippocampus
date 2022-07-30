//
//  CustomTransformable.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.05.22.
//

import Foundation

protocol CustomTransformable {
    associatedtype TransformedValue
    func transform() -> TransformedValue
    init(transformableValue: TransformedValue)
}
