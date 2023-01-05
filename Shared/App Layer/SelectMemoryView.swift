////
////  AreasView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 31.07.22.
////
//
//import SwiftUI
//
//struct SelectMemoryView: View {
//    static let iCloudImage = Image(systemName: "icloud")
//    static let localImage = Image(systemName: "externaldrive")
//
//    @EnvironmentObject var consciousness: Consciousness
//    @State var selection: URL?
//    @State var showAddAreaSheet = false
//
//    var iCloudUrls: [URL] {
//        guard let urls = try? FileManager.default.contentsOfDirectory(at: HippocampusApp.iCloudContainerUrl, includingPropertiesForKeys: nil) else {
//            return []
//        }
//        return relevantUrls(of: urls)
//    }
//
//    var localUrls: [URL] {
//        guard let urls = try? FileManager.default.contentsOfDirectory(at: HippocampusApp.localContainerUrl, includingPropertiesForKeys: nil) else {
//            return []
//        }
//        return relevantUrls(of: urls)
//    }
//
//    func relevantUrls(of urls: [URL]) -> [URL] {
//        urls.filter { URL in
//            URL.pathExtension == HippocampusApp.memoryExtension
//        }
//        .sorted { $0.lastPathComponent < $1.lastPathComponent }
//    }
//
//    var body: some View {
//        Form {
//            Section {
//                MemoryList(urls: iCloudUrls, selection: $selection)
//            } header: {
//                Self.iCloudImage
//                    .font(.system(size: 24))
//            }
//            Section {
//                MemoryList(urls: localUrls, selection: $selection)
//            } header: {
//                Self.localImage
//                    .font(.system(size: 24))
//            }
//        }
//        .padding()
//        .toolbar {
//            ToolbarItemGroup(placement: .primaryAction) {
//                Button {
//                    consciousness.openMemory(url: selection!)
//                } label: {
//                    Image(systemName: "eye")
//                }
//                .disabled(selection == nil)
//                Button {
//                    showAddAreaSheet.toggle()
//                } label: {
//                    Image(systemName: "lightbulb")
//                }
//            }
//        }
//        .sheet(isPresented: $showAddAreaSheet) {
//            CreateMemoryView()
//        }
//    }
//}
//
//extension SelectMemoryView {
//    struct CreateMemoryView: View {
//        @Environment(\.presentationMode) var presentationMode
//        @EnvironmentObject var consciousness: Consciousness
//
//        @State var name: String = ""
//        @State var local: Bool = false
//        @State var finishing: Bool = false
//
//        var exists: Bool {
//            FileManager.default.fileExists(atPath: HippocampusApp.documentURL(name: name, local: local).path)
//        }
//
//        var body: some View {
//            VStack {
//                Text("Neues Gedächtnis")
//                    .font(.headline)
//                HStack {
//                    Group {
//                        if local {
//                            SelectMemoryView.localImage
//                        } else {
//                            SelectMemoryView.iCloudImage
//                        }
//                    }
//                    .font(.system(size: 20))
//                    .onTapGesture {
//                        local.toggle()
//                    }
//
//                    TextField("", text: $name)
//
//                    if exists, !finishing {
//                        Image(systemName: "exclamationmark.triangle")
//                            .foregroundColor(.red)
//                            .font(.system(size: 20))
//                    }
//                }
//            }
//            .padding()
//            .frame(width: 400, height: 100)
//            .toolbar {
//                ToolbarItemGroup {
//                    Button(action: {
//                        finishing = true
//                        consciousness.createMemory(name: name, local: local)
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Text("Anlegen")
//                    }
//                    .disabled(name.isEmpty || exists)
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Text("Abbrechen")
//                    }
//                }
//            }
//        }
//    }
//}
//
//extension SelectMemoryView {
//    struct MemoryList: View {
//        @State var urls: [URL]
//        @Binding var selection: URL?
//
//        var columns = [GridItem(.flexible(minimum: 30, maximum: 60))]
//
//        var body: some View {
//            LazyHGrid(rows: columns, alignment: .top) {
//                ForEach(urls, id: \.self) { url in
//                    MemoryUrlView(url: url, selection: $selection)
//                }
//            }
//        }
//    }
//
//    struct MemoryUrlView: View {
//        @State var url: URL
//        @Binding var selection: URL?
//
//        func name(for url: URL) -> String {
//            String(url.lastPathComponent.dropLast(HippocampusApp.memoryExtension.count + 1))
//        }
//
//        var body: some View {
//            Text(name(for: url))
//                .padding()
//                .if(selection == url) {
//                    $0.background(.selection)
//                }
//                .cornerRadius(12)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    selection = url
//                }
//        }
//    }
//}
