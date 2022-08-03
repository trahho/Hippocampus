//
//  Consciousness.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.22.
//

import Combine
import Foundation

class Consciousness: ObservableObject {
    private var cancellable: AnyCancellable?

    private(set) var area: Brain.Area? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            cancellable = area?.objectWillChange.sink(receiveValue: {
                self.objectWillChange.send()
            })
        }
    }

    var isEmpty: Bool {
        area == nil
    }

    func openArea(url: URL) {
        area = Brain.Area(location: url)
    }

    func createArea(name: String, local: Bool) {
        area = Brain.Area(location: HippocampusApp.areaUrl(name: name, local: local))
        area?.persist()
    }

    func showArea(area: Brain.Area) {
        self.area = area
    }
}
