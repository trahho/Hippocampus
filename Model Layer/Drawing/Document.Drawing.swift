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
    class Drawing: DatabaseDocument {
        @Content var drawing = Drawing()
//        @Content var properties = Properties()
    }
}
