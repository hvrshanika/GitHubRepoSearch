//
//  Networking.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import Foundation

enum Result<Value: Decodable> {
    case success(Value)
    case failure(Bool)
}

protocol Requestable {}

extension Requestable {
    
    internal func request(url: String, callback: @escaping (Result<Data>) -> Void) {

        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url,  completionHandler: { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                            callback(.success(data!))
                    } else {
                        callback(.failure(true))
                    }
                }
        })
        task.resume()
    }
}
