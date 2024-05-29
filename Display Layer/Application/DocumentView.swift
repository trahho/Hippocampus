//
//  HippocampusApp.DocumentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.01.23.
//

import Foundation
import SwiftUI

struct DocumentView: View {
    @State var document: Document

    var body: some View {
        NavigationView()
            .environment(document)
            .environment(document.structure)
            .environment(document.information)
//        NavigationView()
//            .font(.myText)
//            .environment(document)
//            .environment(document.structure)
    }
}
