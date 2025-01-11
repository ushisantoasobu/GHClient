//
//  UserRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

protocol UserRepository {
    func fetch(userName: String) async throws -> [User]
    func fetch(userID: String) async throws -> UserDetail
}

struct MockUserRepository: UserRepository {
    func fetch(userName: String) async throws -> [User] {
        try! await Task.sleep(for: .seconds(2))

        return [
            .init(
                id: UUID().uuidString,
                name: "some name",
                imageURLString: "https://picsum.photos/120/120"
            ),
            .init(
                id: UUID().uuidString,
                name: "some name",
                imageURLString: "https://picsum.photos/120/120"
            ),
            .init(
                id: UUID().uuidString,
                name: "some name",
                imageURLString: "https://picsum.photos/120/120"
            ),
            .init(
                id: UUID().uuidString,
                name: "some name",
                imageURLString: "https://picsum.photos/120/120"
            )
        ]
    }

    func fetch(userID: String) async throws -> UserDetail {
        try! await Task.sleep(for: .seconds(2))
        return .make()
    }
}
