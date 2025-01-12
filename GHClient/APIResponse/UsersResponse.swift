//
//  UsersResponse.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

struct UsersResponse: Decodable {
    let items: [UserResponse]

    func toModel() -> [User] {
        items.map { $0.toModel() }
    }
}
