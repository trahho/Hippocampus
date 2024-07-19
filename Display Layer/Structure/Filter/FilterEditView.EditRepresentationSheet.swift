//
//  FilterEditView.EditRepresentationSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import SwiftUI

extension FilterEditView {
    struct EditRepresentationSheet: View {
        // MARK: Properties

        @Environment(\.document) var document
        @State var representation: Structure.Filter.Representation

        // MARK: Content

        var body: some View {
            VStack(alignment: .leading) {
                ConditionEditView(condition: $representation.condition)
                    .sensitive

                PresentationEditView(presentation: $representation.presentation)
                Divider()
                PresentationView(presentation: representation.presentation, item: Information.Item())
                    .sensitive
                Spacer()
            }
            .padding()
            //            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(minWidth: 600, minHeight: 500)
        }
    }
}
