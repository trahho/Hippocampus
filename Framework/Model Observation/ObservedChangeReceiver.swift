//
//  ObservedChangeReceiver.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.05.22.
//

import Foundation

protocol ObservedChangesReceiver {
    func willChange(observedObject: Any)
}
