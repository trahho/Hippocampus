//
//  ManagedObjectContextChanges.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.05.22.
//

import Combine
import CoreData
import Foundation

struct ManagedObjectContextChanges<T: NSManagedObject> {
    let inserted: Set<T>
    let deleted: Set<T>
    let updated: Set<T>

    init?(notification: Notification) {
        let unpack: (String) -> Set<T> = { key in
            let managedObjects = (notification.userInfo?[key] as? Set<NSManagedObject>) ?? []
            return Set(managedObjects.compactMap { $0 as? T })
        }
        deleted = unpack(NSDeletedObjectsKey)
        inserted = unpack(NSInsertedObjectsKey)
        updated = unpack(NSUpdatedObjectsKey).union(unpack(NSRefreshedObjectsKey))
        if deleted.isEmpty, inserted.isEmpty, updated.isEmpty {
            return nil
        }
    }
}

extension NSManagedObject {
    typealias Result = ManagedObjectContextChanges<NSManagedObject>
    static func getNotifications(for notification: Notification.Name = NSManagedObjectContext.didSaveObjectsNotification, in context: NSManagedObjectContext) -> AnyPublisher<Result, Never> {
        NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap { Result(notification: $0) }
            .eraseToAnyPublisher()
    }
}
