//
//  RepositoryService.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

class RepositoryService: NSObject, Requestable {

    static let instance = RepositoryService()
    
    let repoSearchURL = "https://api.github.com/search/repositories?q="
    
    func fetchRepositories(for query: String, callback: @escaping (Result<Data>) -> Void) {
        request(url: repoSearchURL + query) { (result) in
           callback(result)
        }
    }
    
}
