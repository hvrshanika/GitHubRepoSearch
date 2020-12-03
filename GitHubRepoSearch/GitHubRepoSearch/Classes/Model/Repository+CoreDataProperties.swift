//
//  Repository+CoreDataProperties.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//
//

import Foundation
import CoreData


extension Repository {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Repository> {
        return NSFetchRequest<Repository>(entityName: "Repository")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var size: Int64
    @NSManaged public var hasWiki: Bool
    @NSManaged public var owner: Owner?

}
