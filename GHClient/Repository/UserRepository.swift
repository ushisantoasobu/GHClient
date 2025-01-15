//
//  UserRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

protocol UserRepository {
    func fetch(userName: String, page: Int) async throws -> Paging<User>
}



struct MockUserRepository: UserRepository {
    
    func fetch(userName: String, page: Int) async throws -> Paging<User> {
        try! await Task.sleep(for: .seconds(2))

        return .init(list: [
            .makeExample(),
            .makeExample(),
            .makeExample(),
            .makeExample()
        ], hasNext: false)
    }
}

struct MockUserDetailRepository: UserDetailRepository {

    func fetch(userName: String) async throws -> UserDetail {
        try! await Task.sleep(for: .seconds(2))
        return .make()
    }
}
