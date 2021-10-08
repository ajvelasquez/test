//
//  PostsViewController.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import UIKit

class PostsViewController: UIViewController {
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var postViewDataSource: PostsViewDataSource? {
        didSet {
            tableView.dataSource = postViewDataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Posts"
        
        configDependencies()
        configNavBar()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if segmentedControl.selectedSegmentIndex == 1 {
            postViewDataSource?.setFavoritePosts()
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailsViewController", let vc = segue.destination as? PostDetailsViewController else {
            return
        }
        
        guard let indexPath = tableView.indexPathForSelectedRow?.row, let post = postViewDataSource?.getPost(at: indexPath) else {
            return
        }
        
        vc.post = post
        vc.toggleFavoriteAction = postViewDataSource?.toggleIsFavorite
        vc.postWasReadAction = postViewDataSource?.setWasRead
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            postViewDataSource?.setAllPosts()
        } else {
            postViewDataSource?.setFavoritePosts()
        }
        
        tableView.reloadData()
    }
    
    @IBAction func deleteButtonTouched(_ sender: UIButton) {
        deleteAll()
    }
    
    private func configDependencies() {
        postViewDataSource = PostsViewDataSource()
    }
    
    private func configNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getDataFromRemoteSource))
    }
    
    private func getData(remote: Bool? = false) {
        self.showSpinner()
        
        postViewDataSource?.getData(remote: remote!) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if self?.segmentedControl.selectedSegmentIndex == 1 {
                        self?.postViewDataSource?.setFavoritePosts()
                    }
                    
                    self?.tableView.reloadData()
                    self?.removeSpinner()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func getDataFromRemoteSource() {
        if !self.isSpinnerVisible() {
            deleteAll()
            getData(remote: true)
        }
    }
    
    private func deleteAll() {
        postViewDataSource?.deleteAll() { [weak self] (selectedRows) in
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: selectedRows, with: .automatic)
            self?.tableView.endUpdates()
        }
    }
}
