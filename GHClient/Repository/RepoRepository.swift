//
//  RepoRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

// MEMO: 名前がわかりづらいが「Githubのレポジトリを取り扱うRepository」
protocol RepoRepository {
    func fetch(userName: String) async throws -> [Repository]
}

struct RepoRepositoryImpl: RepoRepository {
    
    func fetch(userName: String) async throws -> [Repository] {
        let urlString = "https://api.github.com/users/\(userName)/repos"
        
        guard let url = URL(string: urlString) else {
            fatalError() // TODO
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //        request.setValue("token \(token)", forHTTPHeaderField: "Authorization") // TODO:
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let repositoriesResponse = try decoder.decode([RepositoryResponse].self, from: data)
        return repositoriesResponse.map { $0.toModel() }
    }
}

struct MockRepoRepository: RepoRepository {
    func fetch(userName: String) async throws -> [Repository] {
        try! await Task.sleep(for: .seconds(1))

        return [
            .make(),
            .make(),
            .make(),
            .make()
        ]
    }
}
