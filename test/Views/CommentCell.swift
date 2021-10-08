//
//  CommentCell.swift
//  test
//
//  Created by Amalio Velasquez on 23/09/21.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet var body: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        body.text = nil
    }
    
    func configure(_ comment: Comment) {
        body.text = comment.body
    }
}
