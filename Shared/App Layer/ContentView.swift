//
//  ContentView.swift
//  Shared
//
//  Created by Guido Kühn on 29.07.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var consciousness: Consciousness

    var body: some View {
        if consciousness.isEmpty {
            SelectMemoryView()
                .frame(minWidth: 400, minHeight: 600, alignment: .topLeading)
        } else {
            TabView {
                ShowConsciousnessView()
                    .tabItem {
                        Label("Brain", systemImage: "brain")
                    }
                Text("Ideen")
                    .tabItem {
                        Label("Ideas", systemImage: "lightbulb")
                    }
                Text("Favoriten")
                    .tabItem {
                        Label("Favourites", systemImage: "heart")
                    }
            }
//              mac   .frame(minWidth: 1200, minHeight: 800, alignment: .topLeading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Consciousness.preview1)
    }
}
