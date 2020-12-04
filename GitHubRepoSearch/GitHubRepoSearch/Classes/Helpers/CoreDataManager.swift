//
//  CoreDataManager.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import UIKit
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

class CoreDataManager: NSObject {
    
    static let instance = CoreDataManager()
    public var persistentContainer: NSPersistentContainer?
    
    // A key to keep the sorted order from the API response
    private var repoSortOrder: Int16 = 0
    
    override private init() {
        super.init()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            persistentContainer = appDelegate.persistentContainer
        }
    }
    
    // Returns a private/background context
    func getNewPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = persistentContainer?.viewContext
        
        return context
    }
    
    // Return the main context -> Always use in Main queue
    func getMainContext() -> NSManagedObjectContext {
        return persistentContainer!.viewContext
    }
    
    func saveContext(forContext context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    // Generate the sorting order
    func getNextSortOrder() -> Int16 {
        repoSortOrder = repoSortOrder + 1
        return repoSortOrder
    }
    
}
