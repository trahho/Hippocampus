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
    typealias Form = Structure.Aspect.Presentation.Form

    @ObservedObject var item: Information.Item
    @EnvironmentObject var document: Document

    var aspect: Structure.Aspect
    var form: String
    var editable: Bool

    var body: some View {
        switch form {
        case Form.icon:
            Image(systemName: "square.and.pencil")
        case Form.normal:
            CanvasView(data: document.getDrawing(item: item, aspect: aspect), editable: editable)
        case Form.edit:
            CanvasView(data: document.getDrawing(item: item, aspect: aspect), editable: true)
        case Form.small:
            ImageView(data: document.getDrawing(item: item, aspect: aspect), scale: 0.5)
        default:
            EmptyView()
        }
    }
}
