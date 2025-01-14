//
//  UserDetailResponse.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

struct UserDetailResponse: Decodable {

    // MEMO: optionalかどうかの判定は https://github.com/octokit/webhooks/blob/78b4df795a42aa00d98b25d24c5ad2a01935a0df/payload-types/schema.d.ts#L800

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
