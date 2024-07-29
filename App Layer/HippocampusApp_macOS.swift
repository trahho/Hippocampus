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
            WindowGroup {
                DocumentView(document: document)
            }
            WindowGroup("Filter", for: Structure.Filter.ID.self) { $filterId in
                if let filterId, let filter = document[Structure.Filter.self, filterId] {
                    FilterEditView(filter: filter)
                        .environment(\.doc, document)
                }
            }
            WindowGroup("Role", for: Structure.Role.ID.self) { $id in
                if let id, let role = document[Structure.Role.self, id] {
                    RoleEditView(role: role)
                        .environment(\.doc, document)
                }
            }
            Window("Export SourceCode", id: "exportSourceCode") {
                ExportSourceCodeView()
                    .environment(\.doc, document)
            }
            Window("Edit Roles", id: "editRoles") {
                RolesView()
                    .environment(\.doc, document)
            }
        }
        .commandsRemoved()
        .commands {
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
