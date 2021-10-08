//
//  PostTransformer.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import Foundation

struct PostTransformer {
    static func transformPosts(posts: [Post]) -> [Post] {
        var newPostList = posts
        for (index, _) in posts.enumerated() {
            newPostList[index].wasRead = index > 19
            newPostList[index].isFavorite = false
        }
        
        return newPostList
    }
    
    static func transformPostsFromCoreData(posts: [PostModel]) -> [Post] {
        return posts.map { posts in
            Post(
                userId: Int(posts.userId),
                id: Int(posts.id),
                title: posts.title!,
                body: posts.body!,
                wasRead: posts.wasRead,
                isFavorite: posts.isFavorite
            )
        }
    }
    
    static func transformCommentsFromCoreData(comments: [CommentModel]) -> [Comment] {
        return comments.map { comment in
            Comment(
                postId: Int(comment.postId),
                id: Int(comment.id),
                email: comment.email!,
                body: comment.body!
            )
        }
    }
}
