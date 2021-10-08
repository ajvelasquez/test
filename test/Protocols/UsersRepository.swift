//
//  UsersRepository.swift
//  test
//
//  Created by Amalio Velasquez on 23/09/21.
//

import Foundation

protocol UsersRepository {
    func getUser(byID id: Int, completion: @escaping (Result<User, Error>) -> Void) -> Void
}
