//
//  Document.Presentation.Properties.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

//import Combine
//import Foundation
//import Smaug
//
//extension Presentation {
////    class Property<T: Codable>: Object, ObservableObject {
////        @PublishedSerialized private var modes: Set<Layout> = []
////        @PublishedSerialized var value: T?
////
////        subscript(mode: Layout) -> Bool {
////            get {
////                modes.isEmpty || modes.contains(mode)
////            }
////            set {
////                if newValue {
////                    modes.insert(mode)
////                } else {
////                    modes.remove(mode)
////                }
////            }
////        }
////    }
//
//    class Properties: Persistent, Serializable, ObservableObject {
//        @PublishedSerialized(notifiyChange: true) var globalValues: [Information.Item.ID: AnyObject] = [:]
//        var objectDidChange = ObjectDidChangePublisher()
//
//        // MARK: - Initialisation
//
//        public required init() {}
//
//        // MARK: - Merging
//
//        func merge(other _: Properties) throws {}
//
//        func restore() {}
//    }
//}
