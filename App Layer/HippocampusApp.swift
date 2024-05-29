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

    static func previewDocument() -> Document {
        let containerURL = URL.virtual
        let url = containerURL.appendingPathComponent("Preview\(HippocampusApp.memoryExtension)")
        let document = Document(url: url)

        for i in 1 ..< 3 {
            let filter = Structure.Filter()
            document[] = filter
            filter.name = "Group \(i)"
            filter.layouts = [.list]
            for j in 1 ..< 4 {
                let subFilter = Structure.Filter()
                document[] = subFilter
                subFilter.filter.append(filter)
                subFilter.name = "Filter \(j)"
            }
        }

        for filter in document.structure.filters {
            filter.order = [.sorted(Structure.Role.text.text.id, ascending: true)]
            filter.condition = .always(true)
            filter.role = Structure.Role.text
        }

        for i in 0 ..< 10 {
            let item = Information.Item()
            item[String.self, Structure.Role.text.text] = "\(i + 1). Hallo Welt🤩"
            item.roles.append(Structure.Role.text)
            document[] = item
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

    let navigation = Navigation()

    var body: some Scene {
        WindowGroup {
//            TestView()
//                .onAppear {
//                    Self.locationService.start()
//                }
//            Text("hello_world")
            DocumentView(document: document)
                .environment(navigation)

//            AnchorGraphView(graph: HippocampusApp.graph)
//            Design_ShellView()
//            Design_ContextMenuView()
//                .environmentObject(navigation)
//                .onOpenURL { document = Document(url: $0) }
        }
    }

    struct TestView: View {
        var body: some View {
            Text("\(HippocampusApp.locationService.authorization.rawValue)")
        }
    }
}
