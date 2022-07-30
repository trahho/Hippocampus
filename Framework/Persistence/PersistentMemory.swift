//
//  PersistentMemory.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.07.22.
//

import Combine
import Foundation

class PersistentMemory<Content: Serializable>: ObservableObject {
    static var containerUrl: URL {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)!
            .appendingPathComponent("Documents")
    }

    let url: URL
    private var currentTimestamp: Date = .distantPast
    private let metadataQuery = NSMetadataQuery()
    private var querySubscriber: AnyCancellable?

    @Observed private var _content: Content
    var content: Content {
        get { _content }
        set {
            objectWillChange.send()
            _content = newValue
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
        guard let data = encode() else { return }

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
        guard let modificationDate = try? FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as? Date,
              modificationDate > currentTimestamp,
              let data = try? Data(contentsOf: url, options: [.uncached])
        else { return }

        decode(data)
        currentTimestamp = modificationDate
    }

    fileprivate func observeChanges() {
        let names: [NSNotification.Name] = [.NSMetadataQueryDidFinishGathering, .NSMetadataQueryDidUpdate]
        let publishers = names.map { NotificationCenter.default.publisher(for: $0) }

        querySubscriber = Publishers.MergeMany(publishers)
            .receive(on: DispatchQueue.main)
            .sink { [self] notification in
                guard let query = notification.object as? NSMetadataQuery, query === self.metadataQuery else { return }
                query.disableUpdates()
                let modificationDate = try? FileManager.default.attributesOfItem(atPath: self.url.path)[.modificationDate] as? Date
                print("MD: \(modificationDate ?? Date.distantPast), CTS: \(currentTimestamp)")
                self.refresh()
                query.enableUpdates()
            }

        metadataQuery.notificationBatchingInterval = 1
        metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        metadataQuery.predicate = NSPredicate(format: "%K == %@", NSMetadataItemPathKey, url.path)
        metadataQuery.start()
    }

    init(url: URL, content: Content) {
        self.url = url
        self._content = content
        observeChanges()
    }

    deinit {
        guard metadataQuery.isStarted else { return }
        metadataQuery.stop()
    }
}
