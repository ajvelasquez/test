//
//  NetworkManagerProtocol.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import Foundation

protocol NetworkManager {
    func get(url: URL, completion: @escaping (Result<Any, Error>) -> Void) -> Void
}
