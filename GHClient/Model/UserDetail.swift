//
//  UserDetail.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

struct UserDetail: Identifiable {
    let id: String
    let imageURLString: String
    let name: String
    let fullName: String
    let followerCount: Int
    let followingCount: Int
}
