//
//  Networking.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

enum Result<Value: Decodable> {
    case success(Value)
    case failure(Bool,String)
}

protocol Requestable {}

extension Requestable {
    
    internal func request(url: String, callback: @escaping (Result<Data>) -> Void) {

        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url,  completionHandler: { (data, response, error) in
                if let error = error {
                    callback(.failure(true, error.localizedDescription))
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                            callback(.success(data!))
                    } else if httpResponse.statusCode == 403 {
                            callback(.failure(true, NSLocalizedString("Rate limit exceeded\nPlease wait for a minute", comment: "")))
                    } else {
                        callback(.failure(true, NSLocalizedString("Error occured while retreiving data", comment: "")))
                    }
                }
        })
        task.resume()
    }
}
