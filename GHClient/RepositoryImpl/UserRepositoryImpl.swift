//
//  UserRepositoryImpl.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/15.
//

import Foundation

struct UserRepositoryImpl: UserRepository {

    func fetch(userName: String, page: Int) async throws -> Paging<User> {
        let urlString = "https://api.github.com/search/users"

        guard let url = URL(string: urlString) else {
            NonFatalErrorLogger().log(error: NonFatalError.failedToCreateGitHubAPIURL)
            throw NonFatalError.failedToCreateGitHubAPIURL
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

        let usersResponse = try apiDecoder.decode(UsersResponse.self, from: data)

        return .init(
            list: usersResponse.toModel(),
            hasNext: GitHubAPIHelper.checkHasNextPage(response: response)
        )
    }
}
