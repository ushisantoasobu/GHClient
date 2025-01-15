//
//  RepoRepositoryImpl.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/15.
//

import Foundation

struct RepoRepositoryImpl: RepoRepository {
    
    func fetch(userName: String, page: Int) async throws -> Paging<Repository> {
        let urlString = "https://api.github.com/users/\(userName)/repos"
        
        guard let url = URL(string: urlString) else {
            NonFatalErrorLogger().log(error: NonFatalError.failedToCreateGitHubAPIURL)
            throw NonFatalError.failedToCreateGitHubAPIURL
        }

        // 更新順（降順）で取得する
        let queryAddedURL = url
            .appending(queryItems: [.init(name: "page", value: "\(page)")])
            .appending(queryItems: [.init(name: "sort", value: "updated")])
            .appending(queryItems: [.init(name: "direction", value: "desc")])

        var request = URLRequest(url: queryAddedURL)
        request.httpMethod = "GET"
        if let pat = GitHubAPIHelper.getPAT() {
            request.setValue("token \(pat)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        let repositoriesResponse = try apiDecoder.decode([RepositoryResponse].self, from: data)

        return .init(
            list: repositoriesResponse.map { $0.toModel() },
            hasNext: GitHubAPIHelper.checkHasNextPage(response: response)
        )
    }
}
