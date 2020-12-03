//
//  Owner+CoreDataClass.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//
//

import Foundation
import CoreData

@objc(Owner)
public class Owner: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
    }
        
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Owner", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(Int64.self, forKey: .id)
            login = try values.decodeIfPresent(String.self, forKey: .login)
        } catch let error {
            print (error)
        }
    }

}
