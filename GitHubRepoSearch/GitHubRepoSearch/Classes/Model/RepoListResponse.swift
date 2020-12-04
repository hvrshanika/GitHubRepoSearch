//
//  RepoListResponse.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

struct RepoListResponse: Decodable {
    
    let total_count : Int?
    let incomplete_results : Bool?
    let items : [Repository]?
    
    enum CodingKeys: String, CodingKey {
        case total_count = "total_count"
        case incomplete_results = "incomplete_results"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
        items = try values.decodeIfPresent([Repository].self, forKey: .items)
    }
    
}

struct RateLimit: Decodable {
    
    let limit : Int?
    let remaining : Int?
    let reset : Int64?
    let used : Int?
    
    enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case remaining = "remaining"
        case reset = "reset"
        case used = "used"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        remaining = try values.decodeIfPresent(Int.self, forKey: .remaining)
        reset = try values.decodeIfPresent(Int64.self, forKey: .reset)
        used = try values.decodeIfPresent(Int.self, forKey: .used)
    }
    
}
