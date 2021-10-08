//
//  PostCell.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        iconImageView.isHidden = true
        label.text = nil
    }
    
    func configure(_ post: Post) {
        label.text = post.body.replacingOccurrences(of: "\n", with: "")
        iconImageView.image = UIImage(named: "circle.fill")
        iconImageView.isHidden = post.wasRead != false
        
        if post.isFavorite == true {
            let image = UIImage(named: "star.fill")
            let tintableImage = image?.withRenderingMode(.alwaysTemplate)
            iconImageView.image = tintableImage
            iconImageView.tintColor = UIColor.systemYellow
            iconImageView.isHidden = false
        }
    }
}
