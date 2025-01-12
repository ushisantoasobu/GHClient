//
//  RepoRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

// MEMO: 名前がわかりづらいが「Githubのレポジトリを取り扱うRepository」
protocol RepoRepository {
    func fetch(userID: Int) async throws -> [Repository]
}

struct MockRepoRepository: RepoRepository {
    func fetch(userID: Int) async throws -> [Repository] {
        try! await Task.sleep(for: .seconds(1))

        return [
            .make(),
            .make(),
            .make(),
            .make()
        ]
    }
}
