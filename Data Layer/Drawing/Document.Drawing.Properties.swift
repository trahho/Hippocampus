//
//  Structure.Aspect.Representation.DrawingView.PersistentData.Properties.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Combine
import Foundation
import PencilKit

extension Document.Drawing {
    class Properties: PersistentContent, Serializable, ObservableObject {
        private var isMerging = false

        @PublishedSerialized var center: CGPoint = .zero
        @PublishedSerialized var pageFormat: PageFormat = .A4
        @PublishedSerialized var background: Background = .shorthandGrid

        // MARK: - Publishers

        var objectDidChange = PassthroughSubject<Void, Never>()

        // MARK: - Initialisation

        public required init() {}

        // MARK: - Merging

        func merge(other: Properties) throws {
            center = other.center
            pageFormat = other.pageFormat
            background = other.background
        }

        func restore() {}
    }
}
