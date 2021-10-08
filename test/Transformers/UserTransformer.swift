//
//  UserTransformer.swift
//  test
//
//  Created by Amalio Velasquez on 23/09/21.
//

import Foundation

struct UserTransformer {
    static func transformUsersFromCoreData(users: [UserModel]) -> [User] {
        return users.map { user in
            User(
                id: Int(user.id),
                name: user.name!,
                email: user.email!,
                phone: user.phone!,
                website: user.website!
            )
        }
    }
}
