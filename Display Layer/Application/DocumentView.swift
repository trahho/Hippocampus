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

//    @Environment(Navigation.self) var navigation

    var body: some View {
//        NavigationView(navigation: navigation)
        NavigationView()
            .setDocument(document)
//        NavigationView()
//            .font(.myText)
//            .environment(document)
//            .environment(document.structure)
    }
}
