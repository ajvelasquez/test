//
//  JSONPlacholderPostsRepository.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import Foundation

class JSONPlacholderPostsRepository: PostsRepository {
    private let remoteProvider: NetworkManager
    private let localProvider: LocalStorageManager
    
    init(networkManager: NetworkManager = URLSessionNetworkManager(), localStorageManager: LocalStorageManager = CoreDataManager()) {
        self.remoteProvider = networkManager
        self.localProvider = localStorageManager
    }
    
    func getPosts(remote: Bool, completion: @escaping (Result<[Post], Error>) -> Void) {
        let localData = localProvider.getPosts()
        
        if (localData.count > 0 && !remote) {
            let posts = PostTransformer.transformPostsFromCoreData(posts: localData)
            completion(Result.success(posts))
        } else {
            remoteProvider.get(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedData = try! decoder.decode([Post].self, from: data as! Data)
                    
                    let posts = PostTransformer.transformPosts(posts: decodedData)
                    
                    posts.forEach { p in
                        self.localProvider.post(post: p)
                    }
                    self.localProvider.saveContext()
                    
                    completion(.success(posts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getComments(byPostID postID: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let localData = localProvider.getComments(postId: postID)
        
        if (localData.count > 0) {
            let comments = PostTransformer.transformCommentsFromCoreData(comments: localData)
            completion(Result.success(comments))
        } else {
            remoteProvider.get(url: URL(string: "https://jsonplaceholder.typicode.com/posts/\(postID)/comments")!) { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let comments = try! decoder.decode([Comment].self, from: data as! Data)
                    
                    DispatchQueue.global().async {
                        comments.forEach { comment in
                            self.localProvider.comment(comment: comment)
                            self.localProvider.saveContext()
                        }
                    }
                    
                    completion(.success(comments))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func toggleIsFavorite(id: Int) {
        localProvider.toggleIsFavorite(id: id)
    }
    
    func setWasRead(id: Int) {
        localProvider.setWasRead(id: id)
    }
    
    func delete(byID id: Int) {
        localProvider.deletePostByID(id)
    }
    
    func deleteAll() {
        localProvider.deleteAllPosts()
    }
}
