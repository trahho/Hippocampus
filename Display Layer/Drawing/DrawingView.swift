//
//  Structure.Aspect.DrawingView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.02.23.
//

import Combine
import Foundation
import PencilKit
import SwiftUI

struct DrawingView: View {
    @ObservedObject var item: Information.Item
    @EnvironmentObject var document: Document

    var aspect: Structure.Aspect
    var form: Structure.Aspect.Presentation.Form
    var editable: Bool

    var body: some View {
        switch form {
        case .icon:
            Image(systemName: "square.and.pencil")
        case .normal:
            CanvasView(data: document.getDrawing(item: item, aspect: aspect), editable: editable)
        case .small:
            ImageView(data: document.getDrawing(item: item, aspect: aspect), scale: 0.5)
        default:
            EmptyView()
        }
    }
}
