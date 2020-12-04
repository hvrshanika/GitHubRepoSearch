//
//  RepoListViewModel.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

class RepoListViewModel {
    
    var errorOccured: ((String) -> Void)?
    
    var searchQuery: String? {
        didSet {
            searchQueryChanged()
        }
    }
    
    var searchRateLimit: RateLimit?
    
    func searchQueryChanged() {
        // Clear the main context to remove previous objects
        let context = CoreDataManager.instance.getMainContext()
        context.reset()
        
        // Reset the currentpage to 0
        RepositoryService.instance.currentPage = 0
        fetchRepoList(for: searchQuery!)
    }
    
    func fetchRepoList(for query: String) {
        
        // Sending the request in Main thread and receiving in a backgorunf thread
        RepositoryService.instance.fetchRepositories(for: query) { result in
            switch result {
            case .success(let data):
                
                // 1. Create the JSON decoder
                let decoder = JSONDecoder()
                
                // 2. Get a new private context to process the json data in the background thread
                let context = CoreDataManager.instance.getNewPrivateContext()
                
                // 3. Set context of the decoder
                decoder.userInfo[CodingUserInfoKey.context!] = context
                
                // 4. Decode the json in background context
                _ = try? decoder.decode(RepoListResponse.self, from: data) as RepoListResponse
                
                // 5. Save the background context
                CoreDataManager.instance.saveContext(forContext: context)
                
                // Once the private context objects gets saved to the main context, fetched results controller's delegate will be triggerd
                
                 /*
                 I'm not saving the main context here. So the objects do not get saved to the database.
                 If needed can be saved here by doing it in the main thread.
                 Then will have to clear the database each time app starts or each time the search query gets changed
                 */
                
                break
            case .failure(let type, let message):
                // Show the error message in main thread
                DispatchQueue.main.async {
                    self.errorOccured!(message)
                }
                
                // Checking if the error was rate limit and requesting for rate limit details
                if type == .rateLimitExceeded {
                    self.fetchRateLimit()
                }
                break
            }
        }
    }
    
    func fetchRateLimit() {
        RepositoryService.instance.fetchRateLimit { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any>
                                  
                    // Get the Rate limit list from resources
                    if let rateLimitDict = json!["resources"] as? Dictionary<String, Any> {
                        if let jsonData: Data = try? JSONSerialization.data(withJSONObject: rateLimitDict, options: []) {
                            let decoder = JSONDecoder()
                            let rateLimits = try decoder.decode([String:RateLimit].self, from: jsonData)
                            
                            self.searchRateLimit = rateLimits["search"]
                        }
                    }
                } catch let jsonError {
                    print(jsonError)
                }
                
                break
            case .failure:
                break
            }
        }
    }
    
}
