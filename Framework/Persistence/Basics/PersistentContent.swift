//
//  PersistentContent.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

protocol PersistentContent: Serializable, DidChangeNotifier {
    func restore() 
}

