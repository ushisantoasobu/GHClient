//
//  UserResponse.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

struct UserResponse: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String

    func toModel() -> User {
        .init(id: id, name: login, imageURLString: avatarUrl)
    }
}
