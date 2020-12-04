//
//  Networking.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

enum ErrorType {
    case rateLimitExceeded
    case other
}

enum Result<Value: Decodable> {
    case success(Value)
    case failure(ErrorType,String)
}

protocol Requestable {}

extension Requestable {
    
    internal func request(url: String, callback: @escaping (Result<Data>) -> Void) {

        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url,  completionHandler: { (data, response, error) in
                if let error = error {
                    callback(.failure(.other, error.localizedDescription))
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                            callback(.success(data!))
                    } else if httpResponse.statusCode == 403 { // Check for rate limit
                        callback(.failure(.rateLimitExceeded, NSLocalizedString("Rate limit exceeded\nPlease wait for a minute", comment: "")))
                    } else { // Other errors
                        callback(.failure(.other, NSLocalizedString("Error occured while retreiving data", comment: "")))
                    }
                }
        })
        task.resume()
    }
}
