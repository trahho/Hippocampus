////
////  PersistentDataContainer.swift
////  Hippocampus
////
////  Created by Guido Kühn on 26.02.23.
////
//
//import Combine
//import Foundation
//
//class PersistentContainer<Content: PersistentContent>: ObservableObject {
//    let url: URL
//    private var currentTimestamp: Date = .distantPast
//    private let metadataQuery = NSMetadataQuery()
//    private var querySubscriber: AnyCancellable?
//    private var contentSubscribers: Set<AnyCancellable> = []
//
//    var didRefresh: (() -> Void)?
//    var willCommit: (() -> Void)?
//    var commitOnChange = false
//    private(set) var hasChanges = false
//
//    private var _content: Content?
//    var content: Content {
//        get { _content! }
//        set {
//            objectWillChange.send()
//            _content = newValue
//            hasChanges = true
//            _content!.objectDidChange
//                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
////                .collect(.byTime(RunLoop.main, .seconds(0.5)))
//                .sink { [self] _ in
//                    if commitOnChange {
//                        save()
//                        hasChanges = false
//                    } else {
//                        hasChanges = true
//                    }
//                }
//                .store(in: &contentSubscribers)
//            if let content = _content as? (any ObservableObject), let publisher = (content.objectWillChange as any Publisher) as? (ObservableObjectPublisher) {
//                publisher
//                    .sink { [self] in
//                        self.objectWillChange.send()
//                    }
//                    .store(in: &contentSubscribers)
//            }
//        }
//    }
//
//    func save() {
////        let fileQueue = DispatchQueue(label: "de.kuehnerleben.Hippocampus.file", qos: .background)
////        fileQueue.async { [self] in
//        print("PersistentDataContainer<\(String(reflecting: Content.self))>: Save")
//        guard !url.isVirtual, let data = content.encode() else { return }
//
//        metadataQuery.stop()
//        willCommit?()
//        url.deletingLastPathComponent().ensureDirectory()
//        try! data.write(to: url, options: [.atomic])
//        currentTimestamp = try! FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as! Date
//        print("Modified \(currentTimestamp)")
//        hasChanges = false
//        metadataQuery.start()
////        }
//    }
//
//    func load() {
//        guard !url.isVirtual else { return }
//        guard
//            let modificationDate = try? FileManager.default.attributesOfItem(atPath: url.path(percentEncoded: false))[.modificationDate] as? Date,
//            modificationDate > currentTimestamp,
//            let data = try? Data(contentsOf: url, options: [.uncached]),
//            let newContent = Content.decode(persistentData: data)
//        else { return }
//        print("PersistentDataContainer<\(String(reflecting: Content.self))>: Load")
//        newContent.restore()
//        do {
//            try content.merge(other: newContent)
//        } catch {
//            content = newContent
//        }
//        currentTimestamp = modificationDate
//        hasChanges = false
//        didRefresh?()
//        print("Updated \(currentTimestamp)")
//    }
//
//    fileprivate func setupMetadataQuery() {
//        guard !url.isVirtual else { return }
//
//        let names: [NSNotification.Name] = [.NSMetadataQueryDidFinishGathering, .NSMetadataQueryDidUpdate]
//        let publishers = names.map { NotificationCenter.default.publisher(for: $0) }
//
//        querySubscriber = Publishers.MergeMany(publishers)
//            .receive(on: DispatchQueue.main)
//            .sink { [self] notification in
//                guard let query = notification.object as? NSMetadataQuery, query === self.metadataQuery else { return }
//                query.disableUpdates()
//                self.load()
//                query.enableUpdates()
//            }
//
//        metadataQuery.notificationBatchingInterval = 0 // .1
//
//        if url.isiCloud {
//            metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
//        } else {
//            #if os(iOS)
//                metadataQuery.searchScopes = [NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope]
//            #endif
//            #if os(macOS)
//                metadataQuery.searchScopes = [NSMetadataQueryLocalComputerScope]
//            #endif
//        }
//
//        let pathPredicate = NSComparisonPredicate(leftExpression: NSExpression(forConstantValue: url.path(percentEncoded: false)),
//                                                  rightExpression: NSExpression(forKeyPath: NSMetadataItemPathKey),
//                                                  modifier: .direct,
//                                                  type: .beginsWith)
//        metadataQuery.predicate = pathPredicate
//        metadataQuery.start()
//        metadataQuery.enableUpdates()
//    }
//
//    init(url: URL, content: Content, commitOnChange: Bool = false) {
//        if url.isiCloud {
//            url.deletingLastPathComponent().startDownloading()
//        }
//        self.url = url
//        self.commitOnChange = commitOnChange
//        self.content = content
//        load()
//        setupMetadataQuery()
//    }
//
//    deinit {
//        guard metadataQuery.isStarted else { return }
//        metadataQuery.stop()
//    }
//}
