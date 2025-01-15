//
//  UserDetailRepositoryImpl.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/15.
//

import Foundation

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

        let userDetailResponse = try apiDecoder.decode(UserDetailResponse.self, from: data)
        return userDetailResponse.toModel()
    }
}
