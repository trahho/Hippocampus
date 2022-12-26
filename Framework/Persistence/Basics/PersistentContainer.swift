//
//  PersistentMemory.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.07.22.
//

import Combine
import Foundation

class PersistentContainer<Content>: ObservableObject where Content: PersistentContent {
    enum Error {
        case mergeFailed
    }

    let url: URL
    private var currentTimestamp: Date = .distantPast
    private let metadataQuery = NSMetadataQuery()
    private var querySubscriber: AnyCancellable?
    private var contentSubscriber: AnyCancellable?
    var didRefresh: (() -> Void)?
    var willCommit: (() -> Void)?
    var commitOnChange = false
    private(set) var hasChanges = false

    private var _content: Content?
    var content: Content {
        get { _content! }
        set {
            objectWillChange.send()
            _content = newValue
            hasChanges = true
            contentSubscriber = newValue.objectDidChange.sink { [self] _ in
                if commitOnChange {
                    commit()
                    hasChanges = false
                } else {
                    hasChanges = true
                }
            }
        }
    }

    func encode() -> Data? {
        guard let flattened = try? CyclicEncoder().flatten(content),
              let data = try? JSONEncoder().encode(flattened),
              let compressedData = try? (data as NSData).compressed(using: .lzfse) as Data
        else { return nil }

        return compressedData

//        guard // let flattened = try? CyclicEncoder().flatten(content),
//              let data = try? JSONEncoder().encode(content)
//        else { return nil }
//
//        return data
    }

    func commit() {
        guard let data = encode(), !url.isVirtual else { return }

        metadataQuery.stop()
        willCommit?()
        let directory = url.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directory.path) {
            try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        try! data.write(to: url, options: [.atomic])
        currentTimestamp = try! FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as! Date
        print("Modified \(currentTimestamp)")
        hasChanges = false
        metadataQuery.start()
    }

    func decode(_ compressedData: Data) {
        guard let data = try? (compressedData as NSData).decompressed(using: .lzfse) as Data,
              let flattened = try? JSONDecoder().decode(FlattenedContainer.self, from: data),
              let newContent = try? CyclicDecoder().decode(Content.self, from: flattened)
        else { return }
        newContent.restore()
        do {
            try content.merge(other: newContent)
        } catch {
            content = newContent
        }
//        guard // let data = try? (compressedData as NSData).decompressed(using: .lzfse) as Data,
//              let newContent = try? JSONDecoder().decode(Content.self, from: compressedData)
        ////              let newContent = try? CyclicDecoder().decode(Content.self, from: flattened)
//        else { return }
//        content = newContent
    }

    func refresh() {
        guard !url.isVirtual else { return }
        guard
            let modificationDate = try? FileManager.default.attributesOfItem(atPath: url.path(percentEncoded: false))[.modificationDate] as? Date,
            modificationDate > currentTimestamp,
            let data = try? Data(contentsOf: url, options: [.uncached])
        else { return }

//        print("MD: \(modificationDate), CTS: \(currentTimestamp)")
        decode(data)
        currentTimestamp = modificationDate
        hasChanges = false
        didRefresh?()
        print("Updated \(currentTimestamp)")
    }

    fileprivate func setupMetadataQuery() {
        guard !url.isVirtual else { return }

        let names: [NSNotification.Name] = [.NSMetadataQueryDidFinishGathering, .NSMetadataQueryDidUpdate]
        let publishers = names.map { NotificationCenter.default.publisher(for: $0) }

        querySubscriber = Publishers.MergeMany(publishers)
            .receive(on: DispatchQueue.main)
            .sink { [self] notification in
//                print("Notification")
                guard let query = notification.object as? NSMetadataQuery, query === self.metadataQuery else { return }
//                print("My notification")
                query.disableUpdates()
//                let modificationDate = try? FileManager.default.attributesOfItem(atPath: self.url.path(percentEncoded: false))[.modificationDate] as? Date
//                print("MD: \(modificationDate ?? Date.distantPast), CTS: \(currentTimestamp)")
                self.refresh()
                query.enableUpdates()
            }

        metadataQuery.notificationBatchingInterval = 1
        if let containerUrl = FileManager.default.url(forUbiquityContainerIdentifier: nil), url.path(percentEncoded: false).starts(with: containerUrl.path(percentEncoded: false)) {
            metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
            if FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) {
//                refresh()
            }
            try? FileManager.default.startDownloadingUbiquitousItem(at: url)
        } else {
            #if os(iOS)
                metadataQuery.searchScopes = [NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope]
            #endif
            #if os(macOS)
                metadataQuery.searchScopes = [NSMetadataQueryLocalComputerScope]
            #endif
        }

        let pathPredicate = NSComparisonPredicate(leftExpression: NSExpression(forConstantValue: url.path(percentEncoded: false)),
                                                  rightExpression: NSExpression(forKeyPath: NSMetadataItemPathKey),
                                                  modifier: .direct,
                                                  type: .beginsWith)
        metadataQuery.predicate = pathPredicate

//        metadataQuery.predicate = NSPredicate(format: "%K == %@", NSMetadataItemPathKey, url.path(percentEncoded: false))
//        metadataQuery.predicate = NSPredicate(format: "%K == %@", NSMetadataItemURLKey, url as NSURL)

        metadataQuery.start()
        metadataQuery.enableUpdates()
    }

    init(url: URL, content: Content) {
        self.url = url
        content.restore()
        self.content = content
        setupMetadataQuery()
    }

    deinit {
        guard metadataQuery.isStarted else { return }
        metadataQuery.stop()
    }
}
