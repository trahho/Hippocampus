//
//  PersistentDataContainer.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.02.23.
//

import Foundation
import Combine

class PersistentDataContainer: ObservableObject {
    let url: URL
    private var currentTimestamp: Date = .distantPast
    private let metadataQuery = NSMetadataQuery()
    private var querySubscriber: AnyCancellable?
    private var contentSubscriber: AnyCancellable?

    var didRefresh: (() -> Void)?
    var willCommit: (() -> Void)?
    var commitOnChange = false
    private(set) var hasChanges = false

    var data: Data

    func save() {
        let fileQueue = DispatchQueue(label: "de.kuehnerleben.Hippocampus.file", qos: .background)
        fileQueue.async { [self] in
            print("PersistentDataContainer: Commit")
            guard !url.isVirtual else { return }

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
    }

    func load() {
        guard !url.isVirtual else { return }
        guard
            let modificationDate = try? FileManager.default.attributesOfItem(atPath: url.path(percentEncoded: false))[.modificationDate] as? Date,
            modificationDate > currentTimestamp,
            let readData = try? Data(contentsOf: url, options: [.uncached])
        else { return }

        data = readData
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
                guard let query = notification.object as? NSMetadataQuery, query === self.metadataQuery else { return }
                query.disableUpdates()
                self.load()
                query.enableUpdates()
            }

        metadataQuery.notificationBatchingInterval = 0.1
        
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
        metadataQuery.start()
        metadataQuery.enableUpdates()
    }

    init(url: URL, data: Data? = nil, commitOnChange: Bool = false) {
        if url.isiCloud {
            try? FileManager.default.startDownloadingUbiquitousItem(at: url.absoluteURL.deletingLastPathComponent())
        }
        self.url = url.absoluteURL
        self.commitOnChange = commitOnChange
        self.data = data ?? Data()
        load()
        setupMetadataQuery()
    }

    deinit {
        guard metadataQuery.isStarted else { return }
        metadataQuery.stop()
    }
}
