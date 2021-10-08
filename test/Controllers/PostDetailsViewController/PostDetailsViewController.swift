//
//  PostDetailsViewController.swift
//  test
//
//  Created by Amalio Velasquez on 23/09/21.
//

import UIKit

class PostDetailsViewController: UIViewController {
    typealias ToggleFavoriteAction = (Post) -> Void
    typealias PostWasReadAction = (Post) -> Void
    
    @IBOutlet var postBody: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var commentsTable: UITableView!
    
    var post: Post?
    var user: User?
    var comments: [Comment] = []
    var toggleFavoriteAction: ToggleFavoriteAction?
    var postWasReadAction: PostWasReadAction?
    var usersRepository: UsersRepository?
    var postsRepository: PostsRepository?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Post Details"
        
        configDependencies()
        configOutlets()
        getData()
        
        commentsTable.dataSource = self
        
        if post?.wasRead == false {
            postWasReadAction?(post!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configNavBar()
    }
    
    private func configDependencies() {
        usersRepository = JSONPlacholderUsersRepository()
        postsRepository = JSONPlacholderPostsRepository()
    }

    private func configNavBar() {
        let imageName = post?.isFavorite == true ? "star.fill" : "star"
        let image = UIImage(named: imageName)!
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchDown)
        
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            barButton.customView!.widthAnchor.constraint(equalToConstant: 20),
            barButton.customView!.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func configOutlets() {
        postBody.text = post!.body.replacingOccurrences(of: "\n", with: "")
        nameLabel.text = user?.name
        emailLabel.text = user?.email
        phoneLabel.text = user?.phone
        websiteLabel.text = user?.website
    }
    
    private func getData() {
        self.showSpinner()
        
        usersRepository?.getUser(byID: post!.userId) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.user = data
                    self?.configOutlets()
                }
                
                self?.postsRepository?.getComments(byPostID: self?.post!.id ?? 0) { [weak self] result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self?.comments = data
                            self?.commentsTable.reloadData()
                            self?.removeSpinner()
                        }
                    case .failure(let error):
                        self?.removeSpinner()
                        print(error)
                    }
                }
            case .failure(let error):
                self?.removeSpinner()
                print(error)
            }
        }
    }
    
    @objc func toggleFavorite() {
        post?.isFavorite?.toggle()
        toggleFavoriteAction?(post!)
        
        configNavBar()
    }
}

extension PostDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentCell.self)")  as? CommentCell else {
            fatalError("CommentCell")
        }
        
        let comment = comments[indexPath.row]
        cell.configure(comment)
        
        return cell
    }
}
