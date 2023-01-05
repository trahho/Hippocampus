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
        return URL.iCloudDirectory.appendingPathComponent("Documents")
    }
    
    static var localContainerUrl: URL {
        return URL.localDirecotry.appendingPathComponent("Hippocampus")
    }
    
    static func documentURL(name: String, local: Bool) -> URL {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let result = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
//        result.ensureDirectory()
        return result
    }
    
    static let memoryExtension = ".memory"
    static let persistentExtension = ".persistent"
    
    @ObservedObject var document: Document =
        //        .preview1
        .init(name: "Test", local: false)
    
    var body: some Scene {
        WindowGroup {
            DocumentView(document: document)
//                .onOpenURL { self._document.wrappedValue = Document(url: $0) }
        }
    }
    
    struct DocumentView: View {
        @ObservedObject var document: Document
        
        var body: some View {
            ContentView()
                .environmentObject(document)
        }
    }
    
//    struct ConsciousnessView: View {
//        @State private var path = NavigationPath()
//        @ObservedObject var consciousness: Consciousness
//        var brain: Brain { consciousness.memory.brain }
//        var mind: Mind { consciousness.memory.mind }
//        var imagination: Imagination { consciousness.memory.imagination }
//
//        var body: some View {
//            NavigationView {
//                ContentView()
//                    .environmentObject(consciousness)
    ////                    .environmentObject(brain)
    ////                    .environmentObject(mind)
    ////                    .environmentObject(imagination)
//                    .environmentObject(consciousness.memory.brain)
//                    .environmentObject(consciousness.memory.mind)
//                    .environmentObject(consciousness.memory.imagination)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        }
//    }
}
