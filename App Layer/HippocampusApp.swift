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

    static var localContainerUrl: URL { URL.localDirecotry.appendingPathComponent("Hippocampus") }

    static func documentURL(name: String, local: Bool) -> URL {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let result = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
        return result
    }

    static let locationService = LocationService()

    @ObservedObject var document: Document =
        //        .preview1
        .init(name: "Test", local: false)

    @StateObject var navigation = Navigation()

    var body: some Scene {
        WindowGroup {
//            NavigationPoCView()
//            TestView()
//                .onAppear {
//                    Self.locationService.start()
//                }
//            Text("hello_world")
//            DocumentView(document: document)
            Design_ShellView()
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
