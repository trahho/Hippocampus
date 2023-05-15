//
//  inPreview.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.23.
//

import Foundation

var inPreview: Bool {
    let result = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    print("\(result ? "---- Preview" : "---- Running")")
    return result
}
