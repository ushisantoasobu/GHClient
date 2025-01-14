//
//  RepositoryResponse.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import Foundation

struct RepositoryResponse: Decodable {

    // MEMO: optionalかどうかの判定は https://github.com/octokit/webhooks/blob/78b4df795a42aa00d98b25d24c5ad2a01935a0df/payload-types/schema.d.ts#L517 を参照

    let id: Int
    let name: String
    let language: String?
    let stargazersCount: Int
    let description: String?
    let htmlUrl: String
    let fork: Bool

    func toModel() -> Repository {
        .init(
            id: id,
            name: name,
            language: language,
            starCount: stargazersCount,
            description: description,
            urlString: htmlUrl,
            isFolked: fork
        )
    }
}
