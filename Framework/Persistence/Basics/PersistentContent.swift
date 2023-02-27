//
//  PersistentContent.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

protocol PersistentContent: Codable, DidChangeNotifier {
    func restore()
    func merge(other: Self) throws
}
