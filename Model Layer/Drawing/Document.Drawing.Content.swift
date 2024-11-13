//
//  Content.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.07.24.
//

import PencilKit
import Smaug
import Grisu

extension Document.Drawing {
    final class Content: PropertyStore {
        // MARK: Properties

        @Property var drawing: PKDrawing = .init()
        @Property var center: CGPoint = .zero
        @Property var pageFormat: PageFormat = .A4
        @Property var background: Background = .shorthandGrid

        // MARK: Lifecycle

        required init() {}
    }
}
