//
//  Owner+CoreDataProperties.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//
//

import Foundation
import CoreData


extension Owner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Owner> {
        return NSFetchRequest<Owner>(entityName: "Owner")
    }

    @NSManaged public var id: Int64
    @NSManaged public var login: String?
    @NSManaged public var repository: NSSet?

}

// MARK: Generated accessors for repository
extension Owner {

    @objc(addRepositoryObject:)
    @NSManaged public func addToRepository(_ value: Repository)

    @objc(removeRepositoryObject:)
    @NSManaged public func removeFromRepository(_ value: Repository)

    @objc(addRepository:)
    @NSManaged public func addToRepository(_ values: NSSet)

    @objc(removeRepository:)
    @NSManaged public func removeFromRepository(_ values: NSSet)

}
