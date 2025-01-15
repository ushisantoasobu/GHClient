//
//  MockRepositories.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/15.
//

import Foundation

struct MockUserRepository: UserRepository {

    func fetch(userName: String, page: Int) async throws -> Paging<User> {
        try! await Task.sleep(for: .seconds(2))

        return .init(list: [
            .example(),
            .example(),
            .example(),
            .example()
        ], hasNext: false)
    }
}

struct MockUserDetailRepository: UserDetailRepository {

    func fetch(userName: String) async throws -> UserDetail {
        try! await Task.sleep(for: .seconds(2))
        return .example()
    }
}

struct MockRepoRepository: RepoRepository {
    func fetch(userName: String, page: Int) async throws -> Paging<Repository> {
        try! await Task.sleep(for: .seconds(1))

        return .init(list: [
            .example(),
            .example(),
            .example(),
            .example()
        ], hasNext: false)
    }
}
