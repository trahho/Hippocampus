//
//  AspectView.AspectDrawing.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI

struct DrawingAspectView: View {
    // MARK: Properties

    @State var item: Information.Item
    @State var aspect: Structure.Aspect
    @State var appearance: Presentation.Appearance
    @State var editable: Bool

    // MARK: Content

    var body: some View {
        EmptyView()
    }
}
