//
//  Repository+CoreDataClass.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//
//

import Foundation
import CoreData

@objc(Repository)
public class Repository: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case size = "size"
        case hasWiki = "has_wiki"
        case owner = "owner"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Repository", in: managedObjectContext)
            else {
                fatalError("decode failure")
        }
        
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int64.self, forKey: .id)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            size = try values.decode(Int64.self, forKey: .size)
            hasWiki = try values.decode(Bool.self, forKey: .hasWiki)
            sortOrder = CoreDataManager.instance.getNextSortOrder()
            owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
        } catch let error {
            print (error)
        }
    }
    
    func getDownloadTimeInMins(for timeStamp: Double) -> Int {
        let bandwidth = 10000 * (1 - exp(-timeStamp/3))
        let estInSecs = Double(size*8000)/bandwidth // Size is in KB, So multiplying it by 8000
        return Int(round(estInSecs/60))
    }
    
}
