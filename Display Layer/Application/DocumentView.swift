//
//  HippocampusApp.DocumentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.01.23.
//

import Foundation
import SwiftUI

struct DocumentView: View {
    // MARK: Properties

    @State var document: Document

    // MARK: Content

//    @Environment(Navigation.self) var navigation

    var body: some View {
//        NavigationView(navigation: navigation)
        NavigationView()
            .environment(\.currentDocument, document)
//        NavigationView()
//            .font(.myText)
//            .environment(document)
//            .environment(document.structure)
    }
}
