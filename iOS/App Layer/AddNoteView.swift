//
//  AddNoteView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 15.11.22.
//

import SwiftUI

struct AddNoteView: View {
    @EnvironmentObject var document: Document
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
                        let node = Information.Node()
                        node[String.self, Structure.Role.note.name] = title
                        node[String.self, Structure.Role.note.text] = text
                        node[role: Structure.Role.note.id]  = true
                        document.information.add(node)
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
