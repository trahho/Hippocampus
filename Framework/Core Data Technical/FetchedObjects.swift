//
//  Fetched.swift
//  PoCCoreDataDirectAccess
//
//  Created by Guido Kühn on 07.05.22.
//

import Combine
import CoreData
import Foundation

@propertyWrapper
class FetchedObjects<Value: NSManagedObject> {
    internal class FetFetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        var objectWillChangePublisher: ObservableObjectPublisher?
        var sender: (() -> Void)?

        func sendChangeNotification() {
            if let sender = sender {
                sender()
            } else {
                objectWillChangePublisher?.send()
            }
        }

        func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
            sendChangeNotification()
        }
    }

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: [Value] {
        get { fatalError() }
        set { fatalError() }
    }

    @Injected(\.viewContext) private var managedObjectContext: NSManagedObjectContext
    private(set) var predicate: NSPredicate?
    private(set) var sortDescriptors: [NSSortDescriptor] = []
    private var delegate = FetFetchedResultsControllerDelegate()

    private var fetchController: NSFetchedResultsController<NSFetchRequestResult>?

    func buildFetchController() {
        guard fetchController == nil else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Value.entity().name!)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = delegate
        fetchController = controller
        try! controller.performFetch()
    }

    var fetchedValues: [Value] {
        if fetchController == nil {
            buildFetchController()
        }
        return fetchController!.fetchedObjects as? [Value] ?? []
    }

    init(predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }

    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped _: ReferenceWritableKeyPath<EnclosingSelf, [Value]>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, FetchedObjects>
    ) -> [Value] {
        get {
            let storage = instance[keyPath: storageKeyPath]
            if storage.delegate.objectWillChangePublisher == nil,
               let publisher = instance.objectWillChange as? ObservableObjectPublisher
            {
                storage.delegate.objectWillChangePublisher = publisher
            }
            if storage.delegate.sender == nil, let receiver = instance as? ObservedChangesReceiver {
                storage.delegate.sender = {
                    receiver.willChange(observedObject: storage)
                }
            }

            return storage.fetchedValues
        }

        set {}
    }

    var projectedValue: FetchedObjects<Value> {
        self
    }

    func configure(predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]? = nil) {
        self.predicate = predicate ?? self.predicate
        self.sortDescriptors = sortDescriptors ?? self.sortDescriptors

        guard let fetchController = fetchController else {
            return
        }

        fetchController.fetchRequest.predicate = self.predicate
        fetchController.fetchRequest.sortDescriptors = self.sortDescriptors
        try! fetchController.performFetch()
        delegate.sendChangeNotification()
    }
}
