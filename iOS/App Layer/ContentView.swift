//
//  ContentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: Document
    var body: some View {
//        ListView(information: document.information, query: Structure.Query.notes)
        DrawingView()
    }
}
