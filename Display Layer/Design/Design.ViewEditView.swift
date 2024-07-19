//
//  Design.ViewEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.06.24.
//

import SwiftUI

struct Design_ViewEditView: View {
    indirect enum Data {
        case simple(String)
        case vertical([Data])
        case horizontal([Data])
    }

    @State var data = Data.vertical([
        .horizontal([.simple("Hallo"), .simple("Welt")]),
        .horizontal([.simple("Hello"), .simple("World")]),
        .horizontal([.simple("Bonjour"), .simple("Monde")])
    ])

//    @State var data = Data.simple("Monde")

    var body: some View {
        HStack {
            Form {
                List {
                    EditView(data: $data, array: .constant([]))
                }
            }
            .formStyle(.grouped)
            DisplayView(data: data)
                .sensitive
        }
    }

    struct ContextMenu: View {
        @Binding var data: Data
        @Binding var array: [Data]
        @State var index: Int

        func add(item: Data) {
            switch data {
            case .horizontal(let array):
                data = .horizontal(array + [item])
            case .vertical(let array):
                data = .vertical(array + [item])
            default:
                break
            }
        }

        func subData() -> [Data] {
            switch data {
            case .horizontal(let array), .vertical(let array):
                array
            default:
                []
            }
        }

        var body: some View {
            Button {
                array.remove(at: index)
            } label: {
                Label("Remove", systemImage: "trash")
            }
            switch data {
            case .simple:
                EmptyView()
            default:
                Menu("Add") {
                    Button("Simple") {
                        add(item: .simple(""))
                    }
                    Button("Horizontal") {
                        add(item: .horizontal([]))
                    }
                    Button("Vertical") {
                        add(item: .vertical([]))
                    }
                }
                Menu("Change to") {
                    Button("Simple") {
                        data = .simple("")
                    }
                    Button("Horizontal") {
                        data = .horizontal(subData())
                    }
                    Button("Vertical") {
                        data = .vertical(subData())
                    }
                }
            }
        }
    }

    struct EditView: View {
        @Binding var data: Data
        @Binding var array: [Data]
        @State var index: Int = .min
        @State var test: Presentation.Alignment = .center
        @State var test2: Int = 0

        var body: some View {
            Group {
                switch data {
                case .simple(let string):
                    TextField("", text: Binding(get: { string }, set: { data = .simple($0) }))
                        .contextMenu {
                            ContextMenu(data: $data, array: $array, index: index)
                        }

                case .vertical(let array):
                    DisclosureGroup {
                        ArrayEditView(array: Binding(get: { array }, set: { data = .vertical($0) }))
                    } label: {
                        Text("Vertical")
                            .contextMenu {
                                ContextMenu(data: $data, array: $array, index: index)
                            }
                    }
                case .horizontal(let array):
                    DisclosureGroup {
                        ArrayEditView(array: Binding(get: { array }, set: { data = .horizontal($0) }))
                    } label: {
                        Text("Horizontal")
                            .contextMenu {
                                ContextMenu(data: $data, array: $array, index: index)
                            }
                    }
                }
            }
        }
    }

    struct ArrayEditView: View {
        @Binding var array: [Data]
        var body: some View {
            ForEach(0..<array.count, id: \.self) { i in
                EditView(data: $array[i], array: $array, index: i)
            }
        }
    }

//    struct HorizontalEditView: View {
//        @Binding var array: [Data]
//        var body: some View {
//            ForEach(0..<array.count, id: \.self) { i in
//                EditView(data: $array[i])
//                    .contextMenu {
//                        Button("remove") {
//                            array.remove(at: i)
//                        }
//                    }
//            }
//        }
//    }

    struct DisplayView: View {
        @State var data: Data
        var body: some View {
            Group {
                switch data {
                case .simple(let string):
                    Text(string)
                case .vertical(let array):
                    VStack(alignment: .leading) {
                        ForEach(0..<array.count, id: \.self) { i in
                            DisplayView(data: array[i])
                        }
                    }
                case .horizontal(let array):
                    HStack(alignment: .firstTextBaseline) {
                        ForEach(0..<array.count, id: \.self) { i in
                            DisplayView(data: array[i])
                        }
                    }
                }
            }
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    Design_ViewEditView()
        .frame(width: 400, height: 400, alignment: .topLeading)
}
