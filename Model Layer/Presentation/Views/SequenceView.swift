//
//  SequenceView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.05.24.
//

import Foundation
import SwiftUI

struct SequenceView: View {
    @Environment(Structure.self) var structure
    @State var items: [Information.Item]
    @State var sequences: [Presentation.Sequence]
    @State var layout: Presentation.Layout

    var body: some View {
//        Text("\(sequences.count)")
        List {
            ForEach(0 ..< sequences.count, id: \.self) { index in
                switch sequences[index] {
                case .ordered(let condition, let orders):
                    CollectionView(items: items, condition: condition, order: orders.first, layout: layout)
                case .unordered(let condition):
                    CollectionView(items: items, condition: condition, layout: layout)
                }
            }
        }
    }
}

#Preview {
    let document = HippocampusApp.previewDocument()

//    let presentation =
//        Presentation.vertical([
//            .normal(.aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)),
//            .normal(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false))
//        ], alignment: .leading)

//        Presentation.exclosing(Presentation.exclosing(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false))

//        Presentation.sequence(
    let sequences: [Presentation.Sequence] = [
        .ordered(.always(true),
//                 order: []
                 order: [.sorted(Structure.Role.text.text.id, ascending: true)]
        )
    ]



    return SequenceView(items: document.information.items.asArray, sequences: sequences, layout: .list)
        .environment(document.structure)
}
