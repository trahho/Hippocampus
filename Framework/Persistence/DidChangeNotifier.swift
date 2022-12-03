//
//  DidChangeNotifier.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation
import Combine

protocol DidChangeNotifier {
    associatedtype ObjectDidChangePublisher: Publisher = ObservableObjectPublisher where ObjectDidChangePublisher.Failure == Never

    var objectDidChange: ObjectDidChangePublisher { get }
}
