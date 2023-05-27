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
        return document
    }

    static let locationService = LocationService()

    @ObservedObject var document: Document =
        //        .preview1
//
        inPreview ? Self.previewDocument() : .init(name: "Test", local: false)

    @StateObject var navigation = Navigation()
    
    static var graph: AnchorGraph = {
        let result = AnchorGraph()
        let a = AnchorGraph.Node()
        let b = AnchorGraph.Node()
        let c = AnchorGraph.Node()
        result.nodes.append(a)
        result.nodes.append(b)
        result.nodes.append(c)
        result.nodes.append( AnchorGraph.Edge(node: a, otherNode: b))
        result.nodes.append( AnchorGraph.Edge(node: b, otherNode: c))
        result.nodes.append( AnchorGraph.Edge(node: c, otherNode: a))

        return result
    }()

    var body: some Scene {
        WindowGroup {
//            TestView()
//                .onAppear {
//                    Self.locationService.start()
//                }
//            Text("hello_world")
            DocumentView(document: document)
//            AnchorGraphView(graph: HippocampusApp.graph)
//            Design_ShellView()
                .environmentObject(navigation)
//                .onOpenURL { document = Document(url: $0) }
        }
    }

    struct TestView: View {
        var body: some View {
            Text("\(HippocampusApp.locationService.authorization.rawValue)")
        }
    }
}
