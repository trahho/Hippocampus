//
//  EditNoteView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.11.22.
//

import SwiftUI

struct TextAspectView: View {
    @ObservedObject var information: Mind.Thing
    let aspect: Aspect
    let mode: Sensation.ReceptionStrength
    let editable: Bool

    var text: Binding<String> {
        Binding(get: {
            guard case let .string(string) = information[aspect] else {
                return ""
            }
            return string
        }, set: { newValue in information[aspect] = .string(newValue) })
    }

    @ViewBuilder var normalView: some View {
        if editable {
            TextField(aspect.designation, text: text)
        } else {
            Text(text.wrappedValue)
        }
    }

    @ViewBuilder var symbolView: some View {
        Image(systemName: "doc.plaintext")
    }

    var body: some View {
        switch mode {
        case .normal:
            normalView
        case .symbol:
            symbolView
        default:
            EmptyView()
        }
    }
}

struct TextEditorAspectView: View {
    @ObservedObject var information: Mind.Thing
    let aspect: Aspect
    let mode: Sensation.ReceptionStrength
    let editable: Bool

    var text: Binding<String> {
        Binding(get: {
            guard case let .string(string) = information[aspect] else {
                return ""
            }
            return string
        }, set: { newValue in information[aspect] = .string(newValue) })
    }

    @ViewBuilder var normalView: some View {
        TextEditor(text: text)
            .disabled(!editable)
    }

    @ViewBuilder var symbolView: some View {
        Image(systemName: "doc.plaintext")
    }

    var body: some View {
        switch mode {
        case .normal:
            normalView
        case .symbol:
            symbolView
        default:
            EmptyView()
        }
    }
}

struct EditNoteView: View {
    @EnvironmentObject var brain: Brain
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var note: Mind.Thing

    let textAspect = Perspective.note.text
    let titleAspect = Perspective.note.name

    var text: Binding<String> {
        Binding(get: {
            guard case let .string(string) = textAspect[note] else {
                return ""
            }
            return string
        }, set: { newValue in textAspect[note] = .string(newValue) })
    }

    var title: Binding<String> {
        Binding(get: {
            guard case let .string(string) = titleAspect[note] else {
                return ""
            }
            return string
        }, set: { newValue in titleAspect[note] = .string(newValue) })
    }

    var body: some View {
        VStack {
            TextAspectView(information: note, aspect: titleAspect, mode: .normal, editable: true)
            TextAspectView(information: note, aspect: textAspect, mode: .normal, editable: true)
            TextEditorAspectView(information: note, aspect: textAspect, mode: .normal, editable: true)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    brain.forget()
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
            brain.dream()
        }
        .onDisappear {
            brain.awaken()
        }
    }
}

// struct EditNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditNoteView()
//    }
// }
