//
//  DidChangeNotifier.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

protocol DidChangeNotifier {
    associatedtype ObjectDidChangePublisher: Publisher = Publisher where
//        ObjectDidChangePublisher.Output == Any ,
        ObjectDidChangePublisher.Failure == Never

    var objectDidChange: ObjectDidChangePublisher { get }
}

// protocol DidChangeNotifier<Key: String, V {
//    associatedtype ObjectDidChangePublisher: Publisher = ObservableObjectPublisher where
////        ObjectDidChangePublisher.Output == PersistentGraph<Key.Change,
//        ObjectDidChangePublisher.Failure == Never
//
//    var objectDidChange: ObjectDidChangePublisher { get }
// }
