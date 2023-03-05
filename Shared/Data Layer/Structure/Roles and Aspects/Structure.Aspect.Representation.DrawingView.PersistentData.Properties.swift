//
//  Structure.Aspect.Representation.DrawingView.PersistentData.Properties.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Combine
import Foundation
import PencilKit

extension Structure.Aspect.Representation.DrawingView.PersistentData {
    class Properties: PersistentContent, Serializable, ObservableObject {
        private var isMerging = false

        @PublishedSerialized var center: CGPoint = .zero
        @PublishedSerialized var pageFormat: PencilCanvasView.PageFormat = .A4
        @PublishedSerialized var background: PencilCanvasView.Background = .shorthandGrid

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
