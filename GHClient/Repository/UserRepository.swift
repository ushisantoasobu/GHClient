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

protocol UserDetailRepository {
    func fetch(userName: String) async throws -> UserDetail
}

struct UserRepoRepositoryImpl: UserRepository {

    func fetch(userName: String, page: Int) async throws -> Paging<User> {
        let urlString = "https://api.github.com/search/users"

        guard let url = URL(string: urlString) else {
            fatalError() // TODO
        }

        let queryAddedURL = url
            .appending(queryItems: [.init(name: "q", value: userName)])
            .appending(queryItems: [.init(name: "page", value: "\(page)")])

        var request = URLRequest(url: queryAddedURL)
        request.httpMethod = "GET"
        if let pat = GitHubAPIHelper.getPAT() {
            request.setValue("token \(pat)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let usersResponse = try decoder.decode(UsersResponse.self, from: data)

        let linkHeader = (response as? HTTPURLResponse)?.allHeaderFields["Link"] as? String
        let hasNextPage = linkHeader?.contains("rel=\"next\"") ?? false

        return .init(list: usersResponse.toModel(), hasNext: hasNextPage)
    }
}

struct UserDetailRepositoryImpl: UserDetailRepository {

    func fetch(userName: String) async throws -> UserDetail {
        let urlString = "https://api.github.com/users/\(userName)"

        guard let url = URL(string: urlString) else {
            fatalError() // TODO
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let pat = GitHubAPIHelper.getPAT() {
            request.setValue("token \(pat)", forHTTPHeaderField: "Authorization")
        }

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let userDetailResponse = try decoder.decode(UserDetailResponse.self, from: data)
        return userDetailResponse.toModel()
    }
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
