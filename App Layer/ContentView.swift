//
//  ContentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: Document
    @State var path : [Information.Item] = []
    var body: some View {
        NavigationStack(path: $path) {
            ListView(information: document.information, query: Structure.Query.notes, path: $path)
            //        DrawingView()
            
                .navigationDestination(for: Information.Item.self) { item in
                    NoteView(editable: true, note: item)
                }
        }
    }
}
