//
//  DidChangeNotifier.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

public protocol DidChangeNotifier {
//    associatedtype ObjectDidChangePublisher: Publisher = Publisher where
////        ObjectDidChangePublisher.Output == Any ,
//        ObjectDidChangePublisher.Failure == Never
    
    typealias ObjectDidChangePublisher = Combine.ObservableObjectPublisher

    var objectDidChange: ObjectDidChangePublisher { get }
}

extension DidChangeNotifier {
   public var objectDidChange: ObjectDidChangePublisher {
        Combine.ObservableObjectPublisher()
    }
}

// protocol DidChangeNotifier<Key: String, V {
//    associatedtype ObjectDidChangePublisher: Publisher = ObservableObjectPublisher where
////        ObjectDidChangePublisher.Output == PersistentGraph<Key.Change,
//        ObjectDidChangePublisher.Failure == Never
//
//    var objectDidChange: ObjectDidChangePublisher { get }
// }
