//
//  LocalStorageManager.swift
//  test
//
//  Created by Amalio Velasquez on 28/10/21.
//

import Foundation

protocol LocalStorageManager {
    func saveContext()
    
    func post(post: Post) -> Void
    
    func user(user: User) -> Void
    
    func comment(comment: Comment) -> Void
    
    func getPosts() -> [PostModel]
    
    func getUser(id: Int) -> [UserModel]
    
    func getComments(postId: Int) -> [CommentModel]
    
    func toggleIsFavorite(id: Int)
    
    func setWasRead(id: Int)
    
    func deletePostByID(_ id: Int)
    
    func deleteAllPosts()
}
