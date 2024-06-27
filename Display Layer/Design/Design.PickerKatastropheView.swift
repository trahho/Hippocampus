//
//  Design.PickerKatastropheView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import SwiftUI

struct Design_PickerKatastropheView: View {
    @State var presentation: Presentation = .horizontal([], alignment: .center)

    var body: some View {
        switch presentation {
        case .horizontal(let array, let alignment):
            Picker("", selection: Binding(get: { alignment }, set: { presentation = .horizontal(array, alignment: $0)})) {
                Text("A")
                    .tag(Presentation.Alignment.leading)
                Text("B")
                    .tag(Presentation.Alignment.center)
                Text("C")
                    .tag(Presentation.Alignment.trailing)
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    Design_PickerKatastropheView()
}
