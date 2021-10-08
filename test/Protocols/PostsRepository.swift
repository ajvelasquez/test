//
//  PostsRepository.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import Foundation

protocol PostsRepository {
    func getPosts(remote: Bool, completion: @escaping (Result<[Post], Error>) -> Void) -> Void
    
    func getComments(byPostID postID: Int, completion: @escaping (Result<[Comment], Error>) -> Void)
    
    func toggleIsFavorite(id: Int)
    
    func setWasRead(id: Int)
    
    func delete(byID id: Int)
    
    func deleteAll()
}
