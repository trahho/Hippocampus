//
//  PersistentContainer.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.02.23.
//

import Combine
import Foundation

protocol PersistentContainerReference {
    func save()
}

class PersistentContainer<Content: PersistentContent>: PersistentContainerReference, ObservableObject {
    let url: URL
    private var isMerging = false
    private var currentTimestamp: Date = .distantPast
    private let metadataQuery = NSMetadataQuery()
    private var querySubscriber: AnyCancellable?
    private var didChangeSubcriber: AnyCancellable?
    private var willChangeSubscriber: AnyCancellable?
    public var dependentContainers: [PersistentContainerReference] = []

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
            registerChanges()
        }
    }

    fileprivate func registerChanges() {
        didChangeSubcriber = content.objectDidChange
            .debounce(for: .seconds(1.5), scheduler: RunLoop.main)
            .sink { [self] _ in
                guard !isMerging else { return }
                if commitOnChange {
                    hasChanges = true
                    save()
                    hasChanges = false
                    dependentContainers.forEach { $0.save() }
                } else {
                    hasChanges = true
                }
            }

        if let content = _content as? (any ObservableObject), let publisher = (content.objectWillChange as any Publisher) as? (ObservableObjectPublisher) {
            willChangeSubscriber = publisher
                .sink { [self] in
                    self.objectWillChange.send()
                    hasChanges = true
                }
        } else {
            willChangeSubscriber?.cancel()
            willChangeSubscriber = nil
        }
    }

    func save() {
//        let fileQueue = DispatchQueue(label: "de.kuehnerleben.Hippocampus.file", qos: .background)
//        fileQueue.async { [self] in
        guard !url.isVirtual, hasChanges, let data = content.encode() else { return }
        print("PersistentDataContainer<\(String(reflecting: Content.self))>: Save")

        metadataQuery.stop()
        willCommit?()
        url.deletingLastPathComponent().ensureDirectory()
        measureDuration("Write data") {
            try! data.write(to: url, options: [.atomic])
        }
        currentTimestamp = try! FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as! Date
        print("Modified \(currentTimestamp)")
        hasChanges = false
        metadataQuery.start()
//        }
    }

    func load() {
        guard !url.isVirtual else { return }
        guard
            let modificationDate = try? FileManager.default.attributesOfItem(atPath: url.path(percentEncoded: false))[.modificationDate] as? Date,
            modificationDate > currentTimestamp
        else {
            if url.isiCloud { url.deletingLastPathComponent().startDownloading() }
            return
        }
        guard
            let data = try? Data(contentsOf: url, options: [.uncached]),
            let newContent = Content.decode(persistentData: data)
        else { return }
        print("PersistentDataContainer<\(String(reflecting: Content.self))>: Load")
        newContent.restore()
        do {
            isMerging = true
            try content.merge(other: newContent)
            isMerging = false
        } catch {
            content = newContent
            isMerging = false
        }
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
//                let items = query.results.compactMap { $0 as? NSMetadataItem }//.filter { $0.value(forAttribute: nsmetdata) as! Bool == false }
                query.disableUpdates()
                self.load()
                query.enableUpdates()
            }

        metadataQuery.notificationBatchingInterval = 0 // .1

        if url.isiCloud {
            metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
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

    init(url: URL, content: Content, commitOnChange: Bool = false) {
        if url.isiCloud {
            url.deletingLastPathComponent().startDownloading()
        }
        self.url = url
        self.commitOnChange = commitOnChange
        self.content = content
        load()
        setupMetadataQuery()
    }

    deinit {
        guard metadataQuery.isStarted else { return }
        metadataQuery.stop()
    }
}

//
// class __PersistentContainer<Content>: ObservableObject where Content: PersistentContent {
//    enum Error {
//        case mergeFailed
//    }
//
//    let url: URL
//    private var currentTimestamp: Date = .distantPast
//    private let metadataQuery = NSMetadataQuery()
//    private var querySubscriber: AnyCancellable?
//    private var contentSubscriber: AnyCancellable?
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
//            contentSubscriber = newValue.objectDidChange
//                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
//                .sink { [self] _ in
//                    if commitOnChange {
//                        commit()
//                        hasChanges = false
//                    } else {
//                        hasChanges = true
//                    }
//                }
//        }
//    }
//
//    func encode() -> Data? {
//        guard let flattened = try? CyclicEncoder().flatten(content),
//              let data = try? JSONEncoder().encode(flattened),
//              let compressedData = try? (data as NSData).compressed(using: .lzfse) as Data
//        else { return nil }
//
//        return compressedData
//
////        guard // let flattened = try? CyclicEncoder().flatten(content),
////              let data = try? JSONEncoder().encode(content)
////        else { return nil }
////
////        return data
//    }
//
//    func commit() {
////        let fileQueue = DispatchQueue(label: "de.kuehnerleben.Hippocampus.file", qos: .background)
////        fileQueue.async { [self] in
//            print("PersistentContainer: Commit")
//            guard !url.isVirtual, let data = encode() else {
//                print("PersistentContainer: Encoding failure")
//                return
//            }
//
//            metadataQuery.stop()
//            willCommit?()
//            let directory = url.deletingLastPathComponent()
//            if !FileManager.default.fileExists(atPath: directory.path) {
//                try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
//            }
//            try! data.write(to: url, options: [.atomic])
//            currentTimestamp = try! FileManager.default.attributesOfItem(atPath: url.path)[.modificationDate] as! Date
//            print("Modified \(currentTimestamp)")
//            hasChanges = false
//            metadataQuery.start()
////        }
//    }
//
//    func decode(_ compressedData: Data) {
//        guard let data = try? (compressedData as NSData).decompressed(using: .lzfse) as Data,
//              let flattened = try? JSONDecoder().decode(FlattenedContainer.self, from: data),
//              let newContent = try? CyclicDecoder().decode(Content.self, from: flattened)
//        else { return }
//        newContent.restore()
//        do {
//            try content.merge(other: newContent)
//        } catch {
//            content = newContent
//        }
////        guard // let data = try? (compressedData as NSData).decompressed(using: .lzfse) as Data,
////              let newContent = try? JSONDecoder().decode(Content.self, from: compressedData)
//        ////              let newContent = try? CyclicDecoder().decode(Content.self, from: flattened)
////        else { return }
////        content = newContent
//    }
//
//    func refresh() {
//        guard !url.isVirtual else { return }
//        guard
//            let modificationDate = try? FileManager.default.attributesOfItem(atPath: url.path(percentEncoded: false))[.modificationDate] as? Date,
//            modificationDate > currentTimestamp,
//            let data = try? Data(contentsOf: url, options: [.uncached])
//        else { return }
//
////        print("MD: \(modificationDate), CTS: \(currentTimestamp)")
//        decode(data)
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
////                print("Notification")
//                guard let query = notification.object as? NSMetadataQuery, query === self.metadataQuery else { return }
////                print("My notification")
//                query.disableUpdates()
////                let modificationDate = try? FileManager.default.attributesOfItem(atPath: self.url.path(percentEncoded: false))[.modificationDate] as? Date
////                print("MD: \(modificationDate ?? Date.distantPast), CTS: \(currentTimestamp)")
//                self.refresh()
//                query.enableUpdates()
//            }
//
//        metadataQuery.notificationBatchingInterval = 1
//        if let containerUrl = FileManager.default.url(forUbiquityContainerIdentifier: nil), url.path(percentEncoded: false).starts(with: containerUrl.path(percentEncoded: false)) {
//            metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
//            if FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) {
////                refresh()
//            }
//            try? FileManager.default.startDownloadingUbiquitousItem(at: url)
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
//
////        metadataQuery.predicate = NSPredicate(format: "%K == %@", NSMetadataItemPathKey, url.path(percentEncoded: false))
////        metadataQuery.predicate = NSPredicate(format: "%K == %@", NSMetadataItemURLKey, url as NSURL)
//
//        metadataQuery.start()
//        metadataQuery.enableUpdates()
//    }
//
//    init(url: URL, content: Content, commitOnChange: Bool = false) {
//        if url.isiCloud {
//            try? FileManager.default.startDownloadingUbiquitousItem(at: url.absoluteURL.deletingLastPathComponent())
//        }
//        self.url = url.absoluteURL
//        self.commitOnChange = commitOnChange
//        content.restore()
//        self.content = content
//        refresh()
//        setupMetadataQuery()
//    }
//
//    deinit {
//        guard metadataQuery.isStarted else { return }
//        metadataQuery.stop()
//    }
// }
//
