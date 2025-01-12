//
//  User.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

struct User: Identifiable {
    let id: Int
    let name: String
    let imageURLString: String
}

extension User {
    static func makeExample() -> User {
        .init(
            id: Int.random(in: 0...1_000_000),
            name: "some name",
            imageURLString: "https://picsum.photos/120/120"
        )
    }
}
