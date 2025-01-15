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
