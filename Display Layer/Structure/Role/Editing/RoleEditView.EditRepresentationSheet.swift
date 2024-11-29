//
//  PerspectiveEditView.EditRepresentationSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import SwiftUI

struct EditRepresentationSheet: View {
    // MARK: Properties

    @Environment(\.document) var document
    @State var perspective: Structure.Perspective
    @State var representation: Structure.Perspective.Representation

    // MARK: Content

    var body: some View {
        VStack(alignment: .leading) {
//                Form {
            TextField("Name", text: $representation.name)
//                }
//                .formStyle(.grouped)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
            LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                ForEach(Presentation.Layout.allCases, id: \.self) { layout in
                    Text(layout.description)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(representation.layouts.contains(layout) ? Color.accentColor : Color.clear)
                        }
                        .onTapGesture {
                            if representation.layouts.contains(layout) {
                                representation.layouts.remove(item: layout)
                            } else {
                                representation.layouts.append(layout)
                            }
                        }
                }
            }

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
