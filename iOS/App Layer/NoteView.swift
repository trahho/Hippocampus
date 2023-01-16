//
//  EditNoteView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.11.22.
//

import SwiftUI

// struct TextAspectView: View {
//    @ObservedObject var information: Information.Thing
//    let aspect: Aspect
//    let mode: Sensation.ReceptionStrength
//    let editable: Bool
//
//    var text: Binding<String> {
//        Binding(get: {
//            guard case let .string(string) = information[aspect] else {
//                return ""
//            }
//            return string
//        }, set: { newValue in information[aspect] = .string(newValue) })
//    }
//
//    @ViewBuilder var normalView: some View {
//        if editable {
//            TextField(aspect.designation, text: text)
//        } else {
//            Text(text.wrappedValue)
//        }
//    }
//
//    @ViewBuilder var symbolView: some View {
//        Image(systemName: "doc.plaintext")
//    }
//
//    var body: some View {
//        switch mode {
//        case .normal:
//            normalView
//        case .symbol:
//            symbolView
//        default:
//            EmptyView()
//        }
//    }
// }

// struct TextEditorAspectView: View {
//    @ObservedObject var information: Mind.Thing
//    let aspect: Aspect
//    let mode: Sensation.ReceptionStrength
//    let editable: Bool
//
//    var text: Binding<String> {
//        Binding(get: {
//            guard case let .string(string) = information[aspect] else {
//                return ""
//            }
//            return string
//        }, set: { newValue in information[aspect] = .string(newValue) })
//    }
//
//    @ViewBuilder var normalView: some View {
//        TextEditor(text: text)
//            .disabled(!editable)
//    }
//
//    @ViewBuilder var symbolView: some View {
//        Image(systemName: "doc.plaintext")
//    }
//
//    var body: some View {
//        switch mode {
//        case .normal:
//            normalView
//        case .symbol:
//            symbolView
//        default:
//            EmptyView()
//        }
//    }
// }

struct NoteView: View {
    @EnvironmentObject var document: Document
    @Environment(\.dismiss) private var dismiss
    @State var editable: Bool = false
    @State var note: Information.Item?

    let textAspect = Structure.Role.note.text
    let titleAspect = Structure.Role.note.name

    var body: some View {
        VStack(alignment: .leading) {
            if let note {
                titleAspect.view(for: note, editable: editable)
                textAspect.view(for: note, editable: editable)
            }
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
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
        .onAppear {
            if editable {
                if note == nil {
                    note = document.information.createNode(roles: [Structure.Role.note])
                }
            }
        }
        .onDisappear {
//            document.save()
        }
    }
}

// struct EditNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditNoteView()
//    }
// }
