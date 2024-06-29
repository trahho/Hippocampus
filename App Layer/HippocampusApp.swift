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

    static func previewDocument() -> Document {
        let containerURL = URL.virtual
        let url = containerURL.appendingPathComponent("Preview\(HippocampusApp.memoryExtension)")
        let document = Document(url: url)

        for i in 1 ..< 3 {
            let filter = Structure.Filter()
            document[] = filter
            filter.name = "Group \(i)"
            filter.layouts = [.list]
            filter.role = Structure.Role.named
            for j in 1 ..< 4 {
                let subFilter = Structure.Filter()
                document[] = subFilter
                subFilter.filter.append(filter)
                subFilter.layouts = [.list]
                subFilter.name = "Filter \(j)"
                subFilter.role = Structure.Role.hierarchical
            }
        }

        for filter in document.structure.filters {
            filter.order = [.sorted(Structure.Role.named[dynamicMember: "name"].id, ascending: true)]
            filter.condition = .always(true)
        }

        for i in 0 ..< 10 {
            let item = Information.Item()
            item[String.self, Structure.Role.named[dynamicMember: "name"]] = "\(i + 1). Hallo Welt🤩"
            item.roles.append(Structure.Role.named)
            item.roles.append(Structure.Role.hierarchical)
            document[] = item
            for _ in 0 ..< 5 {
                let subItem = Information.Item()
                subItem[String.self, Structure.Role.named[dynamicMember: "name"]] = "\(i + 1). Hallo Welt🤩"
                subItem.roles.append(Structure.Role.named)
                item.to.append(subItem)
            }
        }

        return document
    }

    static let locationService = LocationService()

    var document: Document = previewDocument()
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
            EmptyView()
        }
        Window("Edit Role", id: "whatever") {
//            TestView()
//                .onAppear {
//                    Self.locationService.start()
//                }
//            Design_Localization()
//            Design_DragDropView()
            RolesView()
//            PresentationView(presentation: Structure.Role.hierarchical.representations[0].presentation, item: Information.Item())
                .environment(HippocampusApp.editStaticRolesDocument)
//            DocumentView(document: document)
//                .environment(navigation)
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
