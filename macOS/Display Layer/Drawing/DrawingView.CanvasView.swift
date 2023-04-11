//
//  DrawingView.CanvasView(iOS).swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation
import SwiftUI

extension DrawingView {
    struct CanvasView: View {
        @ObservedObject var data: Document.Drawing

        var editable: Bool

        var body: some View {
            ImageView(data: data)
        }
    }
}
