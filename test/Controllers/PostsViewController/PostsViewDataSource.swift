//
//  PostsViewDataSource.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import Foundation
import UIKit

class PostsViewDataSource: NSObject {
    private var posts: [Post] = []
    private var postsToShow: [Post] = []
    private var postsRepository: PostsRepository?
    
    init(postsRepository: PostsRepository = JSONPlacholderPostsRepository()) {
        super.init()
        
        self.postsRepository = postsRepository
    }
    
    func getData(remote: Bool, completion: @escaping (Result<[Post], Error>) -> Void) {
        postsRepository?.getPosts(remote: remote) { [weak self] result in
            switch result {
            case .success(let data):
                self?.posts = data
                self?.postsToShow = data
                completion(.success(data))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setFavoritePosts() {
        postsToShow = posts.filter({ post in
            return post.isFavorite ?? false
        })
    }
    
    func setAllPosts() {
        postsToShow = posts
    }
    
    func getPost(at index: Int) -> Post {
        return postsToShow[index]
    }
    
    func setWasRead(post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {
            return
        }
        
        posts[index].wasRead = true
        
        guard let index2 = postsToShow.firstIndex(where: { $0.id == post.id }) else {
            return
        }
        
        postsToShow[index2].wasRead = true
        
        postsRepository?.setWasRead(id: post.id)
    }
    
    func toggleIsFavorite(post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {
            return
        }
        
        posts[index].isFavorite?.toggle()
        
        guard let index2 = postsToShow.firstIndex(where: { $0.id == post.id }) else {
            return
        }
        
        postsToShow[index2].isFavorite?.toggle()
        
        postsRepository?.toggleIsFavorite(id: post.id)
    }
}

extension PostsViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PostCell.self)", for: indexPath) as? PostCell else {
            fatalError("PostDetailsCell")
        }
        
        let post = postsToShow[indexPath.row]
        cell.configure(post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        delete(at: indexPath.row)
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }) { (_) in
            tableView.reloadData()
        }
    }
    
    func delete(at row: Int) {
        let post = postsToShow[row]
        
        guard let index = postsToShow.firstIndex(where: { $0.id == post.id }) else {
            fatalError("Couldn't find post postsToShow")
        }
        postsToShow.remove(at: index)
        
        guard let index2 = posts.firstIndex(where: { $0.id == post.id }) else {
            fatalError("Couldn't find post in posts")
        }
        
        posts.remove(at: index2)
        
        postsRepository?.delete(byID: post.id)
    }
    
    func deleteAll(completion: ([IndexPath]) -> Void) {
        let selectedRows: [IndexPath] = postsToShow.enumerated().map({ (index, post) in
            IndexPath(row: index, section: 0)
        })
        
        posts = []
        postsToShow = []
        postsRepository?.deleteAll()
        completion(selectedRows)
    }
}
