//
//  JSONPlacholderUsersRepository.swift
//  test
//
//  Created by Amalio Velasquez on 23/09/21.
//

import Foundation

class JSONPlacholderUsersRepository: UsersRepository {
    private let remoteProvider: NetworkManager
    private let localProvider: LocalStorageManager
    
    init(networkManager: NetworkManager = URLSessionNetworkManager(), localStorageManager: LocalStorageManager = CoreDataManager()) {
        self.remoteProvider = networkManager
        self.localProvider = localStorageManager
    }
    
    func getUser(byID id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        let localData = localProvider.getUser(id: id)
        
        if (localData.count > 0) {
            let users = UserTransformer.transformUsersFromCoreData(users: localData)
            completion(Result.success(users[0]))
        } else {
            remoteProvider.get(url: URL(string: "https://jsonplaceholder.typicode.com/users/\(id)")!) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedData = try! decoder.decode(User.self, from: data as! Data)
                    
                    DispatchQueue.global().async {
                        self.localProvider.user(user: decodedData)
                        self.localProvider.saveContext()
                    }
                    
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
