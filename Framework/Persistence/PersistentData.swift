//
//  PersistentMemory.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.07.22.
//

import Combine
import Foundation

extension URL {
    var isVirtual: Bool {
        scheme == "virtual"
    }

    static func virtual() -> URL {
        URL(string: "virtual:///")!
    }
}

protocol PersistentDataDelegate {}

class PersistentData<Content>: ObservableObject where Content: Serializable, Content: ObservableObject {
    let url: URL
    private var currentTimestamp: Date = .distantPast
    private let metadataQuery = NSMetadataQuery()
    private var querySubscriber: AnyCancellable?
    private var contentSubscriber: AnyCancellable?
    var didRefresh: (() -> ())?
    var willCommit: (() -> ())?
    private(set) var hasChanges = false

    private var _content: Content?
    var content: Content {
        get { _content! }
        set {
            objectWillChange.send()
            _content = newValue
            hasChanges = true
            contentSubscriber = newValue.objectWillChange.sink { [self] _ in
                objectWillChange.send()
                hasChanges = true
            }
        }
    }

    func encode() -> Data? {
        guard let flattened = try? CyclicEncoder().flatten(content),
              let data = try? JSONEncoder().encode(flattened),
              let compressedData = try? (data as NSData).compressed(using: .lzfse) as Data
        else { return nil }

        return compressedData
    }

    func commit() {
        guard let data = encode(), !url.isVirtual else { return }

        metadataQuery.stop()
        let directory = url.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directory.path) {
            try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        try! data.write(to: url, options: [.atomic])
        currentTimestamp = try! FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as! Date
        metadataQuery.start()
    }

    func decode(_ compressedData: Data) {
        guard let data = try? (compressedData as NSData).decompressed(using: .lzfse) as Data,
              let flattened = try? JSONDecoder().decode(FlattenedContainer.self, from: data),
              let newContent = try? CyclicDecoder().decode(Content.self, from: flattened)
        else { return }
        content = newContent
    }

    func refresh() {
        guard !url.isVirtual else { return }
        guard let modificationDate = try? FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as? Date,
              modificationDate > currentTimestamp,
              let data = try? Data(contentsOf: url, options: [.uncached])
        else { return }

        decode(data)
        currentTimestamp = modificationDate
    }

    fileprivate func setupMetadataQuery() {
        guard !url.isVirtual else { return }

        let names: [NSNotification.Name] = [.NSMetadataQueryDidFinishGathering, .NSMetadataQueryDidUpdate]
        let publishers = names.map { NotificationCenter.default.publisher(for: $0) }

        querySubscriber = Publishers.MergeMany(publishers)
            .receive(on: DispatchQueue.main)
            .sink { [self] notification in
                guard let query = notification.object as? NSMetadataQuery, query === self.metadataQuery else { return }
                query.disableUpdates()
//                let modificationDate = try? FileManager.default.attributesOfItem(atPath: self.url.path)[.modificationDate] as? Date
//                print("MD: \(modificationDate ?? Date.distantPast), CTS: \(currentTimestamp)")
                self.refresh()
                query.enableUpdates()
            }

        metadataQuery.notificationBatchingInterval = 1
        if let containerUrl = FileManager.default.url(forUbiquityContainerIdentifier: nil), url.path.starts(with: containerUrl.path) {
            metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        } else {
            #if os(iOS)
            metadataQuery.searchScopes = [NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope]
            #endif
            #if os(macOS)
            metadataQuery.searchScopes = [NSMetadataQueryLocalComputerScope]
            #endif
        }

        metadataQuery.predicate = NSPredicate(format: "%K == %@", NSMetadataItemPathKey, url.path)
        metadataQuery.start()
    }

    init(url: URL, content: Content) {
        self.url = url
        self.content = content
        setupMetadataQuery()
    }

    deinit {
        guard metadataQuery.isStarted else { return }
        metadataQuery.stop()
    }
}
