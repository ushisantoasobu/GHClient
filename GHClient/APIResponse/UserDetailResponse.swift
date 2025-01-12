//
//  UserDetailResponse.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

struct UserDetailResponse: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    let name: String?
    let followers: Int
    let following: Int

    func toModel() -> UserDetail {
        .init(
            id: id,
            imageURLString: avatarUrl,
            name: login,
            fullName: name,
            followerCount: followers,
            followingCount: following
        )
    }
}
