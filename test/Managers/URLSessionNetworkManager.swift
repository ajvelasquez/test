//
//  URLSessionNetworkManager.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import Foundation

class URLSessionNetworkManager: NetworkManager {
    func get(url: URL, completion: @escaping (Result<Any, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            completion(.success(data!))
        }.resume()
    }
}
