//
//  URL+virtual.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

extension URL {
    var isVirtual: Bool {
        scheme == "virtual"
    }

    var isLocal: Bool {
        return self.absoluteString.hasPrefix(URL.localDirecotry.absoluteString)
    }
    
    var isiCloud: Bool {
        return self.absoluteString.hasPrefix(URL.iCloudDirectory.absoluteString)
    }

    static var virtual: URL {
        URL(string: "virtual:///")!
    }

    static var iCloudDirectory: URL {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)!
    }

    static var localDirecotry: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func ensureDirectory() {
        if !FileManager.default.fileExists(atPath: self.path) {
            try! FileManager.default.createDirectory(at: self, withIntermediateDirectories: true)
        }
    }
}
