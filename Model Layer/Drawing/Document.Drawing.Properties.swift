////
////  Structure.Aspect.Representation.DrawingView.PersistentData.Properties.swift
////  Hippocampus
////
////  Created by Guido Kühn on 05.03.23.
////
//
//import Combine
//import Foundation
//import PencilKit
//import Smaug
//
//extension Document.Drawing {
//    class Properties: Persistent, Serializable, ObservableObject {
//        private var isMerging = false
//
//        @PublishedSerialized var center: CGPoint = .zero
//        @PublishedSerialized var pageFormat: PageFormat = .A4
//        @PublishedSerialized var background: Background = .shorthandGrid
//
//        // MARK: - Publishers
//
//        var objectDidChange = ObjectDidChangePublisher()
//
//        // MARK: - Initialisation
//
//        public required init() {}
//
//        // MARK: - Merging
//
//        func merge(other: Properties) throws {
//            center = other.center
//            pageFormat = other.pageFormat
//            background = other.background
//        }
//
//        func restore() {}
//    }
//}
