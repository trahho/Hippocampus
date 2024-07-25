//
//  Structure.Aspect.DrawingView.PersistentData.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Combine
import Foundation
import PencilKit
import Smaug

extension Document {
    class Drawing: CacheDatabaseDocument, Hashable {
        // MARK: Properties

        @Property var content: Content = .init()

        // MARK: Static Functions

        static func == (lhs: Document.Drawing, rhs: Document.Drawing) -> Bool {
            lhs.id == rhs.id
        }

        // MARK: Functions

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
