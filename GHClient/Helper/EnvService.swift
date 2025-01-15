//
//  EnvService.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/14.
//

import Foundation

class EnvService {

    static let shared = EnvService()

    private init() {}

    private var dic: [String: String] = [:]

    func configure() {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            NonFatalErrorLogger().log(error: .failedToSetUpEnv)
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            guard let string = String(data: data, encoding: .utf8) else {
                NonFatalErrorLogger().log(error: .failedToSetUpEnv)
                return
            }
            let lines = string.split(separator: "\n")
            lines.forEach { line in
                let components = line.split(separator: "=")
                dic[components[0].trimmingCharacters(in: .whitespaces)] = components[1].trimmingCharacters(in: .whitespaces)
            }
        } catch {
            NonFatalErrorLogger().log(error: .failedToSetUpEnv)
            return
        }
    }

    func getGitHubPAT() -> String? {
        return dic["GHCLIENT_GITHUB_PERSONAL_ACCESS_TOKEN"]
    }
}
