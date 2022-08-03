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

    static func areaUrl(name: String, local: Bool) -> URL {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let areaURL = containerURL.appendingPathComponent("\(name).\(HippocampusApp.brainareaExtension)")
        return areaURL
    }

    static let brainareaExtension = "brainarea"
    static let memoryExtension = "memory"

    @ObservedObject var consciousness: Consciousness =  Consciousness.preview1

    var body: some Scene {
        WindowGroup {
                ContentView()
            .environmentObject(consciousness)
            .onOpenURL { consciousness.openArea(url: $0) }
        }
    }
}
