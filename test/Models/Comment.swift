//
//  Comment.swift
//  test
//
//  Created by Amalio Velasquez on 23/09/21.
//

import Foundation

struct Comment: Codable {
    var postId: Int
    var id: Int
    var email: String
    var body: String
}
