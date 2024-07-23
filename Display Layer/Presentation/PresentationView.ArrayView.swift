//
//  ArrayView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.07.24.
//

import SwiftUI

extension PresentationView {
    struct ArrayView: View {
        // MARK: Properties

        @State var array: [Presentation]
        @State var item: Information.Item?

        // MARK: Content

        var body: some View {
            ForEach(array, id: \.self) { presentation in
                //            if let presentation = array.first{
                PresentationView(presentation: presentation, item: item) // .id(UUID())
            }
        }
    }
}
