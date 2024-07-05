//
//  HippocampusApp.swift
//  Shared
//
//  Created by Guido Kühn on 29.07.22.
//

import SwiftUI

@main
struct HippocampusApp: App {
    static let memoryExtension = ".memory"
    static let persistentExtension = ".persistent"

    static var iCloudContainerUrl: URL { URL.iCloudDirectory.appendingPathComponent("Documents") }

    static var localContainerUrl: URL { URL.localDirectory.appendingPathComponent("Hippocampus") }

    static func documentURL(name: String, local: Bool) -> URL {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let result = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
        return result
    }

    static var editStaticRolesDocument: Document {
        let containerURL = URL.virtual
        let url = containerURL.appendingPathComponent("Preview\(HippocampusApp.memoryExtension)")
        let document = Document(url: url)
        document.structure.roles.forEach { $0.toggleStatic() }
        return document
    }

    static var previewDocument: Document {
        let containerURL = URL.virtual
        let url = containerURL.appendingPathComponent("Preview\(HippocampusApp.memoryExtension)")
        let document = Document(url: url)

        for i in 1 ..< 3 {
            let filter = document(Structure.Filter.self)
            
            filter.name = "Group \(i)"
            filter.layouts = [.list]
            filter.role = Structure.Role.note
            for j in 1 ..< 4 {
                let subFilter = document(Structure.Filter.self)
                document[] = subFilter
                subFilter.filter.append(filter)
                subFilter.layouts = [.canvas]
                subFilter.name = "Filter \(j)"
                subFilter.role = Structure.Role.topic
            }
        }

        for filter in document.structure.filters {
            filter.order = [.sorted(Structure.Role.named[dynamicMember: "name"].id, ascending: true)]
//            filter.roots = .always(true)
//            filter.leafs = .always(true)
        }

        for i in 0 ..< 10 {
            let item = document(Information.Item.self)
            Structure.Role.named[dynamicMember: "name"][String.self, item] = "\(i + 1). Hallo Welt🤩"
//            item.roles.append(Structure.Role.named)
            item.roles.append(Structure.Role.topic)
            document[] = item
            for j in 0 ..< 5 {
                let subItem = document(Information.Item.self)
                Structure.Role.named[dynamicMember: "name"][String.self, subItem] = "\(i + 1).\(j + 1). Hallo Welt🤩"
//                subItem.roles.append(Structure.Role.named)
                subItem.roles.append(Structure.Role.topic)

                subItem.from.append(item)
                for k in 0 ..< 5 {
                    let subsubItem = document(Information.Item.self)
                    Structure.Role.named[dynamicMember: "name"][String.self, subsubItem] = "\(i + 1).\(j + 1).\(k + 1). Hallo Welt🤩"
                    subsubItem.roles.append(Structure.Role.note)
                    subItem.to.append(subsubItem)
                    subsubItem.to.append(item)
                }
            }
        }

        return document
    }

    static let locationService = LocationService()

    var document: Document = previewDocument
    //        .preview1
//
//        inPreview ? Self.previewDocument() : .init(name: "Test", local: false)

//    @StateObject var navigation = Navigation()

//    static var graph: AnchorGraph = {
//        let result = AnchorGraph()
//        let a = AnchorGraph.Node()
//        let b = AnchorGraph.Node()
//        let c = AnchorGraph.Node()
//        result.nodes.append(a)
//        result.nodes.append(b)
//        result.nodes.append(c)
//        result.nodes.append( AnchorGraph.Edge(node: a, otherNode: b))
//        result.nodes.append( AnchorGraph.Edge(node: b, otherNode: c))
//        result.nodes.append( AnchorGraph.Edge(node: c, otherNode: a))
//
//        return result
//    }()

//    let navigation = Navigation()

    var body: some Scene {
        WindowGroup {
            DocumentView(document: document)
                .environment(Navigation())
        }
        Window("Edit Role", id: "whatever") {
//            TestView()
//                .onAppear {
//                    Self.locationService.start()
//                }
//            Design_Localization()
//            Design_DragDropView()
            RolesView()
//            PresentationView.Preview()
//            PresentationView(presentation: Structure.Role.hierarchical.representations[0].presentation, item: Information.Item())
                .environment(HippocampusApp.editStaticRolesDocument)

            // Design_NavigationView()
//                .environment(Design_NavigationView.Navigation())
//            AnchorGraphView(graph: HippocampusApp.graph)
//            Design_ShellView()
//            Design_ContextMenuView()
//                .environmentObject(navigation)
//                .onOpenURL { document = Document(url: $0) }
        }
        .keyboardShortcut("r", modifiers: [.command, .control, .shift, .option])
    }

    struct TestView: View {
        var body: some View {
            Text("\(HippocampusApp.locationService.authorization.rawValue)")
        }
    }
}
