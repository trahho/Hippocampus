//
//  AddNoteView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 15.11.22.
//

import SwiftUI

struct AddNoteView: View {
    @EnvironmentObject var brain: Brain
    @Environment(\.dismiss) private var dismiss

    @State var title: String = ""
    @State var text: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Titel", text: $title)
                TextEditor(text: $text)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        brain.dream {
                            let neuron = try! brain.createNeuron()
                            neuron[Perspective.note.name] = title
                            neuron[Perspective.note.text] = text
                        }
                        dismiss()
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
