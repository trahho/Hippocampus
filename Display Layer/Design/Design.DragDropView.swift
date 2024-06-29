//
//  Design.DragDropView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.06.24.
//

import SwiftUI

struct Design_DragDropView: View {
    var input: String = "hello world"
    @State var output: String = " "

    var body: some View {
        VStack {
            Text(input)
                .frame(width: 100, height: 50)
                .border(Color.blue, width: 2)
                .draggable(input)

            List {
                ForEach(1..<4) { row in
//                    GridRow {
                        ForEach(1..<4) { column in
                            Text("\(row) , \(column)")
                                .frame(width: 100, height: 50)
                                .border(Color.red, width: 2)
                        }
//                    }
                }
            }.dropDestination(for: String.self) { _, location in
                output = "\(location.x), \(location.y)"
                return true
            }

            Group {
                ForEach(1..<4) { i in
                    Text("\(i)")
                        .frame(width: 100, height: 50)
                        .border(Color.green, width: 2)
                }.dropDestination(for: String.self) { _, location in
                    output = "\(location)"
                }
            }

            Text(output)
                .frame(width: 200, height: 50)
                .border(Color.cyan, width: 2)
        }
    }
}

struct Design_DragDropView_: View {
    @State var target = "Welcome"
    @State var targets = ["Hello", "World", "Good", "Bye"]
    @State var destination = ""
    var body: some View {
        VStack {
            Text("\(destination)")
            HStack {
                List {
                    ForEach(targets, id: \.self) { _ in
                        Text(target)
                    }
                    .dropDestination(for: String.self) { _, index in
//                    guard let item = items.first else { return false }
//                    target = "\(item) . \(index)"
                        destination = "\(index)"
                        return true
                    }
                }
                ForEach(1..<4) { _ in
                    Text("Hello, World!")
                        .draggable("Hallo", preview: {
                            Text("Hallo Welt")
                        })
                    //                .onDrag {
                    //                    print("Dragged"); return NSItemProvider()
                    //                } preview: {
                    //                    Text("Hallo Welt")
                    //                }
                    Spacer()
                }
            }
        }
        .frame(width: 400, height: 300, alignment: .center)
    }
}

#Preview {
    Design_DragDropView()
}
