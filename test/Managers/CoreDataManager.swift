//
//  CoreDataManager.swift
//  test
//
//  Created by Amalio Velasquez on 28/09/21.
//

import Foundation
import CoreData

class CoreDataManager: LocalStorageManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func post(post: Post) -> Void {
        let postModel = PostModel(context: persistentContainer.viewContext)
        postModel.userId = Int16(post.userId)
        postModel.id = Int16(post.id)
        postModel.title = post.title
        postModel.body = post.body
        postModel.wasRead = post.wasRead ?? false
        postModel.isFavorite = post.isFavorite ?? false
    }
    
    func user(user: User) -> Void {
        let userModel = UserModel(context: persistentContainer.viewContext)
        userModel.id = Int16(user.id)
        userModel.name = user.name
        userModel.email = user.email
        userModel.phone = user.phone
        userModel.website = user.website
    }
    
    func comment(comment: Comment) -> Void {
        let commentModel = CommentModel(context: persistentContainer.viewContext)
        commentModel.postId = Int16(comment.postId)
        commentModel.id = Int16(comment.id)
        commentModel.email = comment.email
        commentModel.body = comment.body
    }
    
    func getPosts() -> [PostModel] {
        let request: NSFetchRequest<PostModel> = PostModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        var result: [PostModel] = []
        
        do {
            result = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fecthing posts from local data")
        }
        
        return result
    }
    
    func getUser(id: Int) -> [UserModel] {
        let request: NSFetchRequest<UserModel> = UserModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", String(id))
        var result: [UserModel] = []
        
        do {
            result = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fecthing posts from local data")
        }
        
        return result
    }
    
    func getComments(postId: Int) -> [CommentModel] {
        let request: NSFetchRequest<CommentModel> = CommentModel.fetchRequest()
        request.predicate = NSPredicate(format: "postId = %@", String(postId))
        
        var result: [CommentModel] = []
        
        do {
            result = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fecthing posts from local data")
        }
        
        return result
    }
    
    func toggleIsFavorite(id: Int) {
        let request: NSFetchRequest<PostModel> = PostModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", String(id))
        
        do {
            let post = try persistentContainer.viewContext.fetch(request)
            post[0].isFavorite = !post[0].isFavorite
            saveContext()
        } catch {
            print("Error toggleIsFavorite")
        }
    }
    
    func setWasRead(id: Int) {
        let request: NSFetchRequest<PostModel> = PostModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", String(id))
        
        do {
            let post = try persistentContainer.viewContext.fetch(request)
            post[0].wasRead = true
            saveContext()
        } catch {
            print("Error toggleIsFavorite")
        }
    }
    
    func deletePostByID(_ id: Int) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostModel")
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = persistentContainer.viewContext
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            fatalError(error.description)
        }
    }
    
    func deleteAllPosts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = persistentContainer.viewContext
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            fatalError(error.description)
        }
    }
}
