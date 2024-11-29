//
//  HippocampusApp_iOS.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.07.24.
//

import SwiftUI

extension HippocampusApp: App {
//    var body: some Scene {
//        WindowGroup {
//            Design_BorderPointView()
//        }
//    }

    var body: some Scene {
        Group {
            WindowGroup(id: "Main") {
                DocumentView(document: document)
                    .environment(\.document, document)
            }
//            .windowStyle(.hiddenTitleBar)
//            .windowToolbarStyle(.expanded)
            WindowGroup("Filter", for: Structure.Filter.ID.self) { $filterId in
                if let filterId, let filter = document[Structure.Filter.self, filterId] {
                    FilterEditView(filter: filter)
                        .environment(\.document, document)
                }
            }
            WindowGroup("Perspective", for: Structure.Perspective.ID.self) { $id in
                if let id, let perspective = document[Structure.Perspective.self, id] {
                    PerspectiveEditView(perspective: perspective)
                        .environment(\.document, document)
                }
            }
            Window("Export SourceCode", id: "exportSourceCode") {
                ExportSourceCodeView()
                    .environment(\.document, document)
            }
            Window("Edit Perspectives", id: "editPerspectives") {
                PerspectivesView()
                    .environment(\.document, document)
            }
            Window("Design", id: "design") {
                Design_Background()

//                DocumentView(document: HippocampusApp.previewDocument)
//                    .environment(\._document, HippocampusApp.previewDocument)
            }
        }
        .commandsRemoved()
//        .commandsReplaced(content: {
//            CommandGroup(replacing: ., addition: <#T##() -> View#>)
//        })
        .commands {
            TextEditingCommands()

            CommandGroup(after: .appInfo) {
                Button(action: {
                    NSApplication.shared.terminate(self)
                }) {
                    Text("Quit Hippocampus")
                }
                .keyboardShortcut("q", modifiers: .command)
            }
            CommandGroup(before: .windowArrangement) {
                Button("New Window") {
                    openWindow(id: "Main")
                }
            }
            CommandMenu("Design") {
                Button("New Filter") {
                    let filter = document(Structure.Filter.self)
                    openWindow(value: filter.id)
                }
                Button("New Perspective") {
                    let perspective = document(Structure.Perspective.self)
                    openWindow(value: perspective.id)
                }
                Divider()
                Button("Export SourceCode") {
                    openWindow(id: "exportSourceCode")
                }
                Button("Edit Perspectives") {
                    openWindow(id: "editPerspectives")
                }
                Divider()
                Button("Show Design") {
                    openWindow(id: "design")
                }
                .keyboardShortcut("d", modifiers: [.command, .shift])
            }
        }
    }
}

// extension HippocampusApp: App {
//    var body: some Scene {
////        Group {
////            WindowGroup {
////                DocumentView(document: document)
////                //            EmptyView()
////            }
////            WindowGroup("filter", for: Structure.Filter.ID.self) { $filterId in
////                if let filterId, let filter = document[Structure.Filter.self, filterId] {
////                    FilterEditView(filter: filter)
////                        .environment(\.currentDocument, document)
////                }
////            }
////            Window("Export SourceCode", id: "exportSourceCode") {
////                ExportSourceCodeView()
////                    .environment(\.currentDocument, document)
////            }
////            Window("Edit Perspective", id: "perspectiveEditor") {
////                //            TestView()
////                //                .onAppear {
////                //                    Self.locationService.start()
////                //                }
////                //            Design_Localization()
////                //            Design_DragDropView()
////                PerspectivesView()
////                    //            PresentationView.Preview()
////                    //            PresentationView(presentation: Structure.Perspective.hierarchical.representations[0].presentation, item: Information.Item())
////                    .environment(\.currentDocument, document)
////
////                // Design_NavigationView()
////                //                .environment(Design_NavigationView.Navigation())
////                //            AnchorGraphView(graph: HippocampusApp.graph)
////                //            Design_ShellView()
////                //            Design_ContextMenuView()
////                //                .environmentObject(navigation)
////                //                .onOpenURL { document = Document(url: $0) }
////            }
////            .keyboardShortcut("r", modifiers: [.command, .control, .shift, .option])
//            WindowGroup {
//                Text("Hallo")
//            }
////        }
////        .commandsRemoved()
//    }
// }
