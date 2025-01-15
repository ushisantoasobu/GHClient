//
//  ModelExamples.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/15.
//

import Foundation

extension User {
    static func example() -> User {
        .init(
            id: Int.random(in: 0...1_000_000),
            name: "some name",
            imageURLString: "https://picsum.photos/120/120"
        )
    }
}

extension UserDetail {
    static func example() -> UserDetail {
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

extension Repository {
    static func example() -> Repository {
        .init(
            id: Int.random(in: 0...1_000_000),
            name: "Alamofire",
            language: "Swiift",
            starCount: 12345,
            description: "Alamofire is an HTTP networking library written in Swift.",
            urlString: "https://github.com/Alamofire/Alamofire",
            isForked: false
        )
    }
}
