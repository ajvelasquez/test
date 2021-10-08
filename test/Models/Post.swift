//
//  Post.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import Foundation

struct Post: Codable, Equatable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var wasRead: Bool?
    var isFavorite: Bool?
}
