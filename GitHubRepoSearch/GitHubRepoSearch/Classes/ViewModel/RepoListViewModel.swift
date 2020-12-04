//
//  RepoListViewModel.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

class RepoListViewModel {
    
    var errorOccured: ((String) -> Void)?
        
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
                
                break
            case .failure(let error, let message):
                if error {
                    // Show the error message in main thread
                    DispatchQueue.main.async {
                        self.errorOccured!(message)
                    }
                }
            }
        }
    }
    
}
