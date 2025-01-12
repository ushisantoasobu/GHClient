//
//  UserDetail.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

struct UserDetail: Identifiable {
    let id: Int
    let imageURLString: String
    let name: String
    let fullName: String?
    let followerCount: Int
    let followingCount: Int
}

extension UserDetail {
    
    static func make() -> UserDetail {
        .init(
            id: Int.random(in: 0...1_000_000),
            imageURLString: "https://picsum.photos/120/120",
            name: "ushisantoasobu",
            fullName: "佐藤 俊輔",
            followerCount: 12,
            followingCount: 4
        )
    }
}
