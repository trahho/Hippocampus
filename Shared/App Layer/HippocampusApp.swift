//
//  HippocampusApp.swift
//  Shared
//
//  Created by Guido Kühn on 29.07.22.
//

import SwiftUI

@main
struct HippocampusApp: App {
    
    static var iCloudContainerUrl: URL {
        let containerUrl = FileManager.default.url(forUbiquityContainerIdentifier: nil)!
        return containerUrl.appendingPathComponent("Documents")
    }

    static var localContainerUrl: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("Hippocampus")
    }

    static func memoryUrl(name: String, local: Bool) -> URL {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let areaURL = containerURL.appendingPathComponent("\(name).\(HippocampusApp.memoryExtension)")
        return areaURL
    }

    static let memoryExtension = "memory"
    static let persistentExtension = "persistent"

    @ObservedObject var consciousness: Consciousness =
//        .preview1
    Consciousness(name: "Test", local: true)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(consciousness)
                .onOpenURL { consciousness.openMemory(url: $0) }
        }
    }
}
