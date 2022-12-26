//
//  PersistentContent.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

protocol PersistentContent: Serializable, DidChangeNotifier {
  
    func restore()
    func merge(other: Self) throws
}

protocol MergeablePersistentContent: PersistentContent {
    func merge<Self>(other: Self) where Self: MergeablePersistentContent
}
