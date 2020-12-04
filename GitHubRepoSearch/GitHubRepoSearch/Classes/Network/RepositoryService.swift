//
//  RepositoryService.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

// https://docs.github.com/en/free-pro-team@latest/rest/reference/search#search-repositories
// https://docs.github.com/en/free-pro-team@latest/rest/reference/rate-limit

class RepositoryService: NSObject, Requestable {

    static let instance = RepositoryService()
    
    // Pagination
    var currentPage = 0
    let maxNumberOfItems = 1000 // API will return only 1000 items for each search query
    let itemsPerPage = 10
    
    let repoSearchURL = "https://api.github.com/search/repositories?q="
    let rateLimitURL = "https://api.github.com/rate_limit"
    
    func fetchRepositories(for query: String, callback: @escaping (Result<Data>) -> Void) {
        
        // Increment current page for each function call
        // If the search query changes current page will revert to 0 from VM
        currentPage += 1
        
        let totalPages = maxNumberOfItems/itemsPerPage
        if currentPage > totalPages {
            callback(.failure(.other, NSLocalizedString("Maximum number of items retrieved", comment: "")))
            return
        }
        
        let urlStr = "\(repoSearchURL)\(query)&per_page=\(itemsPerPage)&page=\(currentPage)"
        
        request(url: urlStr) { (result) in
           callback(result)
        }
    }
    
    func fetchRateLimit(callback: @escaping (Result<Data>) -> Void) {
        request(url: rateLimitURL) { (result) in
           callback(result)
        }
    }
    
}
