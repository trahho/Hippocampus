//
//  ConditionEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.07.24.
//

import Grisu
import SwiftUI

struct ConditionEditView: View {
    @Binding var condition: Information.Condition

    var body: some View {
//        Form {
            ItemEditView(condition: $condition, array: .constant([]))
//        }
        .formStyle(.grouped)
    }
}

//#Preview {
//    @Previewable @State var condition: Information.Condition = .perspective(Structure.Perspective.drawing.id)
//    ConditionEditView(condition: $condition)
////        .setDocument(HippocampusApp.previewDocument)
//        .environment(\._document, HippocampusApp.previewDocument)
//}
