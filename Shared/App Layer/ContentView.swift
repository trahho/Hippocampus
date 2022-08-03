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
            SelectAreaView()
                .frame(minWidth: 400, minHeight: 600, alignment: .topLeading)
        } else {
            ShowAreaView()
                .frame(minWidth: 1200, minHeight: 800, alignment: .topLeading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
