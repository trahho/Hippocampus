//
//  NSManagedObjectContext+saveChanges.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.05.22.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveChanges() {
        guard hasChanges else { return }
        do {
            try save()
            if let parent = parent {
                parent.saveChanges()
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
