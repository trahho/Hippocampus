//
//  Area.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Foundation

extension Brain {
    class Area: ObservableObject {
        @Observed private var persistentBrain: PersistentData<Brain>

        private var url: URL

        var brain: Brain {
            persistentBrain.content
        }

        func persist() {
            persistentBrain.commit()
        }

        init(location url: URL) {
            self.url = url
            let brainURL = url.appendingPathComponent("brain." + HippocampusApp.memoryExtension)
            persistentBrain = PersistentData<Brain>.init(url: brainURL, content: Brain())
        }

        private convenience init() {
            self.init(location: URL.virtual())
        }
        
        static func makeVirtualArea() -> Area {
            Area.init()
        }
    }
}
