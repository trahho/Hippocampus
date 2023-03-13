//
//  DrawingView.ImageView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 11.03.23.
//

import AppKit
import Foundation
import SwiftUI

extension DrawingView {
    struct ImageView: View {
        @ObservedObject var data: Document.Drawing

        var scale: CGFloat = 1

        var body: some View {
            let image = data.image
            if image.size == CGSize(width: 1, height: 1) {
                Image(systemName: "square.slash")
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: image.size.width * scale, height: image.size.height * scale)
            }
        }
    }
}
