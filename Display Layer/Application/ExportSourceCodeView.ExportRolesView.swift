//
//  ExportPerspectivesView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.07.24.
//

import Grisu
import SwiftUI

extension ExportSourceCodeView {
    struct ExportPerspectivesView: View {
        // MARK: Properties

        @Environment(\.document) var document
        @State var fileUrl: URL?
        @State var selectedPerspectives: [Structure.Perspective] = []
        @State var importFile = false
        @State var showExportConfirmation = false
        @State var showDeleteConfirmation = false

        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            return formatter
        }()

        // MARK: Computed Properties

        var perspectives: [Structure.Perspective] {
            document.structure.perspectives.asArray
                .filter { $0 != Structure.Perspective.Statics.same }
                .sorted(by: { $0.description < $1.description })
        }

        var perspectivesSourceCode: String {
            //        let selectedPerspectives = selectedPerspectives
            //            .compactMap { document[Structure.Perspective.self, $0] }

            let samePerspective = Structure.Perspective(id: "00000000-0000-0000-0000-000000000001".uuid)
            samePerspective.name = "same"

            var result = """
            //
            //  \(fileUrl?.lastPathComponent ?? "No file selected")
            //  Hippocampus
            //
            //  Created by Guido Kühn on 19.06.24.
            //  Generated by Hippocampus on \(formatter.string(from: Date())).
            //

            import Foundation
            import SwiftUI
            import Grisu

            extension Structure.Perspective {
                typealias Perspective = Structure.Perspective
                typealias Aspect = Structure.Aspect
                typealias Particle = Structure.Particle


            """
            result += "\tstatic var statics: [Perspective] { ["
                + selectedPerspectives.sorted(by: { $0.name < $1.name })
                .map { "Statics." + $0.name.sourceCode }
                .joined(separator: ", ")
                + "] }\n\n"

            let selectedPerspectives = selectedPerspectives.sorted(by: { $0.name < $1.name })
            let perspectives = [samePerspective] + selectedPerspectives

            result += "\tenum Statics {"
                + perspectives
                .map { $0.sourceCode(tab: 2, inline: false, document: document) }
                .joined(separator: "\n") + "\n"
                + "\t}\n}\n"

            return result
        }

        // MARK: Content

        var body: some View {
            VStack(alignment: .leading) {
                Form {
                    Text(fileUrl?.path ?? "No file selected")
                        .onTapGesture {
                            importFile.toggle()
                        }
                        .fileImporter(
                            isPresented: $importFile,
                            allowedContentTypes: [.swiftSource],
                            allowsMultipleSelection: false
                        ) { result in
                            switch result {
                            case let .success(files):
                                let file = files.first!
                                let gotAccess = file.startAccessingSecurityScopedResource()
                                if !gotAccess { return }
                                analyzeFile(file)
                                file.stopAccessingSecurityScopedResource()
                            case let .failure(error):
                                // handle error
                                print(error)
                            }
                        }
                    SelectorView(data: perspectives, selection: $selectedPerspectives) { Text($0.description) }
                    Text(perspectivesSourceCode)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .font(.system(size: 8))
                }
                .formStyle(.grouped)

                HStack {
                    Button("Create static perspective") {
                        let perspective = Structure.Perspective()
                        perspective.name = "Static Perspective"
                        try! document.$structure.addStaticObject(item: perspective)
                    }

                    Button("Export") {
                        showExportConfirmation.toggle()
                    }
                    .disabled(selectedPerspectives.isEmpty || fileUrl == nil)
                    .confirmationDialog("Export", isPresented: $showExportConfirmation) {
                        Button("Export") {
                            Task {
                                guard let fileUrl, fileUrl.startAccessingSecurityScopedResource() else { return }
                                try! perspectivesSourceCode.write(to: fileUrl, atomically: true, encoding: .utf8)
                                fileUrl.stopAccessingSecurityScopedResource()
                                selectedPerspectives
                                    .filter { !$0.isStatic }
                                    .forEach {
                                        do {
                                            try document.$structure.makeObjectStatic(item: $0)
                                        } catch {}
                                    }
                                showDeleteConfirmation = selectedPerspectives.contains(where: { !$0.isStatic })
                            }
                        }
                    }
                    .confirmationDialog("Delete", isPresented: $showDeleteConfirmation) {
                        Button("Delete") {
                            Task {
                                selectedPerspectives
                                    .filter { !$0.isStatic }
                                    .forEach {
                                        document.delete($0)
                                    }
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }

        // MARK: Functions

        func analyzeFile(_ file: URL) {
            let text = try! String(contentsOf: file, encoding: .utf8)
            let regex = /let perspective = Perspective\(id: "(.*)".uuid\)/
            let declarations = text.split(separator: "\n")
                .compactMap { try? regex.firstMatch(in: $0) }
                .map { String($0.1).uuid }
                .compactMap { document[Structure.Perspective.self, $0] }
                .filter { $0 != Structure.Perspective.Statics.same }

            guard !declarations.isEmpty else {
                // Hier wird der Text auf ein leeres File gecheckt, das dann gefüllt wird.
                var text = text
                text.removeAll(where: { $0.isWhitespace })
                if text.isEmpty {
                    fileUrl = file
                }
                return
            }

            selectedPerspectives = declarations
            fileUrl = file
        }
    }

//    #Preview {
//        ExportSourceCodeView()
//            .environment(\.document, HippocampusApp.previewDocument)
//    }
}
