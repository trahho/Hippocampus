//
//  Aspect+Sensation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.09.22.
//

import Foundation
import SwiftUI

class Sensation: PersistentObject, ObservableObject {
    @Serialized var genes: Genes = Genes()

    func getExpression(for storage: Mind.Thing) {
        fatalError()
    }
    
}

class CompoundSensation: Sensation {
    @Serialized var impressions: [Sensation]
    
}

class SingleSensation: Sensation {
    @Serialized var perspectiveDesignation: String
    
    override func getExpression(for storage: Mind.Thing) {
        
    }
}

extension Sensation {
    enum Perception {}

    enum ReceptionStrength: Codable {
        case invisible, symbol, normal
    }

    struct Reception: View {
        @ObservedObject var storage: Mind.Thing
        var aspect: Aspect

        var body: some View {
            switch aspect.representation {
            case .text:
                TextView(storage: storage, aspect: aspect)
            default:
                EmptyView()
            }
        }

        struct TextView: View {
            @EnvironmentObject var genes: Genes
            @ObservedObject var storage: Mind.Thing
            var aspect: Aspect

            var text: Binding<String> {
                Binding(get: { aspect[storage] ?? "" }, set: { newValue in aspect[storage] = newValue })
            }

            @ViewBuilder var normalView: some View {
                if genes.editable {
                    TextField("", text: text)
                } else {
                    Text(text.wrappedValue)
                }
            }

            @ViewBuilder var symbolView: some View {
                Image(systemName: "doc.plaintext")
            }

            var body: some View {
                switch genes.strength {
                case .normal:
                    normalView
                case .symbol:
                    symbolView
                default:
                    EmptyView()
                }
            }
        }
    }
}

// extension Aspect {
//    struct Sensation: View {
//
//    }
//
//    func sensation(for storage: Mind.Thing) -> Sensation {
//        Sensation(storage: storage, aspect: self)
//    }
// }

// extension Aspect {
//    enum Variation {
//        case icon, small, normal
//    }
//
//    func sensation(for storage: any AspectStorage, variation: Variation) ->  View {
//        switch self.representation {
//        case .text:
//            switch variation {
//            case .icon:
//                return Image(systemName: "doc.plaintext")
//            case .small:
//                return EmptyView()
//            case .normal:
//                return TextView(storage: Storage(storage: storage), aspect: self)
//            }
//        case .drawing:
//            switch variation {
//            case .icon:
//                return Image(systemName: "scribble")
//            case .small:
//                return EmptyView()
//            case .normal:
//                return EmptyView()
//            }
//        }
//    }
// }
//
// class Storage: ObservableObject {
//    var storage: any AspectStorage
//
//    init(storage: any AspectStorage) {
//        self.storage = storage
//    }
// }
//
// struct TextView: View {
//    @ObservedObject var storage: Storage
//    var aspect: Aspect
//
//    var body: some View {
//        Text(aspect[storage.storage, ""])
//    }
// }

// extension Binding where Value: Codable {
//    init(_ storage: any AspectStorage, _ aspect: Aspect) {
//        self.init(
//            get: { aspect[storage] },
//            set: { newValue in
//                aspect[storage] = newValue
//            }
//        )
//    }
// }

//    class Sensation<Content: SensationDisplayView>: IdentifiableObject, ObservableObject {
//        enum Variation {
//            case small, normal
//        }
//
//        typealias displayBuilder = (Aspect, any AspectStorage) -> any SensationDisplayView
//
//        @PublishedSerialized var variation: Variation
//        @PublishedSerialized var representation: Aspect.Representation
//
//        func display(aspect: Aspect, storage: any AspectStorage) -> Content {
//            Content(aspect: aspect, storage: storage)
//        }
//
//        init(_ representation: Aspect.Representation, _ variation: Variation) {
//            super.init()
//            self.variation = variation
//            self.representation = representation
//        }
//    }
//
//    class Storage: ObservableObject {
//        var storage: any AspectStorage
//
//        init(storage: any AspectStorage) {
//            self.storage = storage
//        }
//    }
// }
//
// protocol SensationDisplayView: View {
//    var aspect: Aspect { get set }
//    var storage: Senses.Storage { get set }
//    init(aspect: Aspect, storage: any AspectStorage)
// }
//
// extension SensationDisplayView {}
//
// struct TextNormalView: SensationDisplayView {
//    init(aspect: Aspect, storage: any AspectStorage) {
//        self.aspect = aspect
//        self.storage = Senses.Storage(storage: storage)
//    }
//
//    var aspect: Aspect
//    @ObservedObject var storage: Senses.Storage
//
//    var information: any AspectStorage {
//        storage.storage
//    }
//
//    var body: some View {
//        Text(aspect[information, ""])
//    }
// }
