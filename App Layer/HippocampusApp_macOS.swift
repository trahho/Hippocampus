//
//  HippocampusApp_iOS.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.07.24.
//

import SwiftUI

extension HippocampusApp: App {
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
            WindowGroup("Role", for: Structure.Role.ID.self) { $id in
                if let id, let role = document[Structure.Role.self, id] {
                    RoleEditView(role: role)
                        .environment(\.document, document)
                }
            }
            Window("Export SourceCode", id: "exportSourceCode") {
                ExportSourceCodeView()
                    .environment(\.document, document)
            }
            Window("Edit Roles", id: "editRoles") {
                RolesView()
                    .environment(\.document, document)
            }
            Window("Design", id: "design") {
                DocumentView(document: HippocampusApp.previewDocument)
//                DocumentView(document: HippocampusApp.previewDocument)
//                    .environment(\._document, HippocampusApp.previewDocument)
            }
        }
        .commandsRemoved()
        .commands {
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
                Button("New Role") {
                    let role = document(Structure.Role.self)
                    openWindow(value: role.id)
                }
                Divider()
                Button("Export SourceCode") {
                    openWindow(id: "exportSourceCode")
                }
                Button("Edit Roles") {
                    openWindow(id: "editRoles")
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
////            Window("Edit Role", id: "roleEditor") {
////                //            TestView()
////                //                .onAppear {
////                //                    Self.locationService.start()
////                //                }
////                //            Design_Localization()
////                //            Design_DragDropView()
////                RolesView()
////                    //            PresentationView.Preview()
////                    //            PresentationView(presentation: Structure.Role.hierarchical.representations[0].presentation, item: Information.Item())
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
