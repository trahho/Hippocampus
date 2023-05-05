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
            CanvasView(data: document[Document.Drawing.self, "\(item.id) - \(aspect.id)"], editable: editable)
        case Form.edit:
            CanvasView(data: document[Document.Drawing.self, "\(item.id) - \(aspect.id)"], editable: true)
        case Form.small:
            ImageView(data: document[Document.Drawing.self, "\(item.id) - \(aspect.id)"], scale: 0.5)
        default:
            EmptyView()
        }
    }
}
