//
//  HippocampusApp.DocumentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.01.23.
//

import Foundation
import SwiftUI

struct DocumentView: View {
    @ObservedObject var document: Document

    var body: some View {
        ContentView()
            .font(.myText)
            .environmentObject(document)
    }
}
