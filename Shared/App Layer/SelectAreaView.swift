//
//  AreasView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.22.
//

import SwiftUI

struct SelectAreaView: View {
    static let iCloudImage = Image(systemName: "icloud")
    static let localImage = Image(systemName: "externaldrive")

    @EnvironmentObject var consciousness: Consciousness
    @State var selection: URL?
    @State var showAddAreaSheet = false

    var iCloudAreas: [URL] {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: HippocampusApp.iCloudContainerUrl, includingPropertiesForKeys: nil) else {
            return []
        }
        return relevantUrls(of: urls)
    }

    var localAreas: [URL] {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: HippocampusApp.localContainerUrl, includingPropertiesForKeys: nil) else {
            return []
        }
        return relevantUrls(of: urls)
    }

    func relevantUrls(of urls: [URL]) -> [URL] {
        urls.filter { URL in
            URL.pathExtension == HippocampusApp.brainareaExtension
        }
        .sorted { $0.lastPathComponent < $1.lastPathComponent }
    }

    var body: some View {
        Form {
            Section {
                AreaList(areas: iCloudAreas, selection: $selection)
            } header: {
                Self.iCloudImage
                    .font(.system(size: 24))
            }
            Section {
                AreaList(areas: localAreas, selection: $selection)
            } header: {
                Self.localImage
                    .font(.system(size: 24))
            }
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    consciousness.openArea(url: selection!)
                } label: {
                    Image(systemName: "eye")
                }
                .disabled(selection == nil)
                Button {
                    showAddAreaSheet.toggle()
                } label: {
                    Image(systemName: "lightbulb")
                }
            }
        }
        .sheet(isPresented: $showAddAreaSheet) {
            AddAreaView()
        }
    }
}

extension SelectAreaView {
    struct AddAreaView: View {
        @Environment(\.presentationMode) var presentationMode
        @EnvironmentObject var consciousness: Consciousness

        @State var name: String = ""
        @State var local: Bool = false
        @State var finishing: Bool = false

        var exists: Bool {
            FileManager.default.fileExists(atPath: HippocampusApp.areaUrl(name: name, local: local).path)
        }

        var body: some View {
            VStack {
                Text("Neues Areal")
                    .font(.headline)
                HStack {
                    Group {
                        if local {
                            SelectAreaView.localImage
                        } else {
                            SelectAreaView.iCloudImage
                        }
                    }
                    .font(.system(size: 20))
                    .onTapGesture {
                        local.toggle()
                    }

                    TextField("", text: $name)

                    if exists && !finishing {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                }
            }
            .padding()
            .frame(width: 400, height: 100)
            .toolbar {
                ToolbarItemGroup {
                    Button(action: {
                        finishing = true
                        consciousness.createArea(name: name, local: local)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Anlegen")
                    }
                    .disabled(name.isEmpty || exists)
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Abbrechen")
                    }
                }
            }
        }
    }
}

extension SelectAreaView {
    struct AreaList: View {
        @State var areas: [URL]
        @Binding var selection: URL?

        var columns = [GridItem(.flexible(minimum: 30, maximum: 60))]

        var body: some View {
            LazyHGrid(rows: columns, alignment: .top) {
                ForEach(areas, id: \.self) { url in
                    AreaView(area: url, selection: $selection)
                }
            }
        }
    }

    struct AreaView: View {
        @State var area: URL
        @Binding var selection: URL?

        func name(for url: URL) -> String {
            String(url.lastPathComponent.dropLast(HippocampusApp.brainareaExtension.count + 1))
        }

        var body: some View {
            Text(name(for: area))
                .padding()
                .if(selection == area) {
                    $0.background(.selection)
                }
                .cornerRadius(12)
                .contentShape(Rectangle())
                .onTapGesture {
                    selection = area
                }
        }
    }
}
