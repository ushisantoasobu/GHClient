//
//  UserRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

protocol UserRepository {
    func fetch(userName: String) async throws -> [User]
    func fetch(userID: Int) async throws -> UserDetail
}

struct UserRepoRepositoryImpl: UserRepository {

    func fetch(userName: String) async throws -> [User] {
        let urlString = "https://api.github.com/search/users"

        guard let url = URL(string: urlString) else {
            fatalError() // TODO
        }

        let queryAddedURL = url.appending(queryItems: [.init(name: "q", value: userName)])

        var request = URLRequest(url: queryAddedURL)
        request.httpMethod = "GET"
//        request.setValue("token \(token)", forHTTPHeaderField: "Authorization") // TODO:

        let (data, response) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let usersResponse = try decoder.decode(UsersResponse.self, from: data)
        return usersResponse.toModel()
    }

    func fetch(userName: String) async throws -> UserDetail {
        let urlString = "https://api.github.com/users/\(userName)"

        guard let url = URL(string: urlString) else {
            fatalError() // TODO
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.setValue("token \(token)", forHTTPHeaderField: "Authorization") // TODO:

        let (data, response) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let userDetailResponse = try decoder.decode(UserDetailResponse.self, from: data)
        return userDetailResponse.toModel()
    }
}

struct MockUserRepository: UserRepository {
    func fetch(userName: String) async throws -> [User] {
        try! await Task.sleep(for: .seconds(2))

        return [
            .makeExample(),
            .makeExample(),
            .makeExample(),
            .makeExample()
        ]
    }

    func fetch(userID: Int) async throws -> UserDetail {
        try! await Task.sleep(for: .seconds(2))
        return .make()
    }
}
