//
//  AspectView.AspectDrawing.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI

extension AspectView {
    struct DrawingAspectView: View {
        @State var item: Information.Item
        @State var aspect: Structure.Aspect
        @State var appearance: Presentation.Appearance
        @State var editable: Bool
        
        var body: some View {
            EmptyView()
        }
    }
}
