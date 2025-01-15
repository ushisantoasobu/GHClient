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
