//
//  RepoRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

// MEMO: 名前がわかりづらいが「Githubのレポジトリを取り扱うRepository」
protocol RepoRepository {
    func fetch(userName: String, page: Int) async throws -> Paging<Repository>
}

struct RepoRepositoryImpl: RepoRepository {
    
    func fetch(userName: String, page: Int) async throws -> Paging<Repository> {
        let urlString = "https://api.github.com/users/\(userName)/repos"
        
        guard let url = URL(string: urlString) else {
            fatalError() // TODO
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

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let repositoriesResponse = try decoder.decode([RepositoryResponse].self, from: data)

        let linkHeader = (response as? HTTPURLResponse)?.allHeaderFields["Link"] as? String
        let hasNextPage = linkHeader?.contains("rel=\"next\"") ?? false

        return .init(list: repositoriesResponse.map { $0.toModel() }, hasNext: hasNextPage)
    }
}

struct MockRepoRepository: RepoRepository {
    func fetch(userName: String, page: Int) async throws -> Paging<Repository> {
        try! await Task.sleep(for: .seconds(1))

        return .init(list: [
            .make(),
            .make(),
            .make(),
            .make()
        ], hasNext: false)
    }
}
